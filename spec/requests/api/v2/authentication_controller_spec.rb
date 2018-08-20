# frozen_string_literal: true

require 'rails_helper'
require 'shared/api/v1/shared_expectations'

RSpec.describe Api::V2::AuthenticationController, type: :request do
  include RequestHelpers

  describe 'POST api/v2/fcm' do
    let(:application) { create(:application) }
    let(:user) { create(:user) }
    let(:token) do
      Doorkeeper::AccessToken.create! application_id: application.id,
                                      resource_owner_id: user.id
    end
    let (:request) { '/api/v2/fcm' }
    let!(:token_name) { '2253703421' }

    context 'with a valid api-token' do
      before do
        post request,
             headers: {
               'Authorization': "Bearer #{token.token}",
               'Content-Type': 'application/vnd.api+json'
             },
             params: {
               fcmToken: token_name
             }.to_json
      end

      it 'adds the fcm token to the user' do
        fcm_token = user.fcm_tokens.find_by_token(token_name)

        expect(fcm_token).to_not be_nil
      end

      expect_status_201_created
    end

    context 'with an invalid api-token' do
      before do
        post request,
             headers: {
               'Authorization': 'Invalid token',
               'Content-Type': 'application/vnd.api+json'
             },
             params: {
               fcmToken: token_name
             }.to_json
      end

      it 'does not add the fcm token to the user' do
        fcm_token = user.fcm_tokens.find_by_token(token_name)

        expect(fcm_token).to be_nil
      end

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        post request,
             headers: {
               'Content-Type': 'application/vnd.api+json'
             },
             params: {
               fcmToken: token_name
             }.to_json
      end

      it 'does not add the fcm token to the user' do
        fcm_token = user.fcm_tokens.find_by_token(token_name)

        expect(fcm_token).to be_nil
      end

      expect_status_401_unauthorized
    end
  end
end
