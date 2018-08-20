# frozen_string_literal: true

require 'rails_helper'
require 'shared/api/v1/shared_expectations'
require 'base64'

RSpec.describe Api::V2::TransactionsController, type: :request do
  include RequestHelpers

  describe 'PUT api/v2/invites/:id' do
    let(:application) { create(:application) }
    let(:team) { create(:team) }
    let(:user) { create(:user) }
    let(:token) do
      Doorkeeper::AccessToken.create! application_id: application.id,
                                      resource_owner_id: user.id
    end
    let(:invite) { TeamInvite.create(user: user, team: team) }
    let(:request) { "/api/v2/invites/#{invite.id}" }
    let(:bad_request) { '/api/v2/invites/999' }

    context 'accepting a invite' do
      before do
        put request,
            headers: {
              'Authorization': "Bearer #{token.token}",
              'Content-Type': 'application/vnd.api+json'
            },
            params: {
              accept: true
            }.to_json
      end

      it 'sets the accepted_at date' do
        expect(TeamInvite.find(invite.id).accepted_at).to_not eql(nil)
      end

      it 'adds a new member to the team' do
        expect(TeamMember.find_by_user_id_and_team_id(user.id, team.id)).to be_present
      end

      it 'returns a success message' do
        expected = {
          "data": {
            "title": 'Successfully accepted the invite',
            "detail": "The team_invite record identified by id #{invite.id} was accepted successfully."
          }
        }.with_indifferent_access
        expect(json).to eq(expected)
      end
    end

    context 'declining a invite' do
      before do
        put request,
            headers: {
              'Authorization': "Bearer #{token.token}",
              'Content-Type': 'application/vnd.api+json'
            },
            params: {
              accept: false
            }.to_json
      end

      it 'sets the declined_at date' do
        expect(TeamInvite.find(invite.id).declined_at).to_not eql(nil)
      end

      it 'returns a success message' do
        expected = {
          "data": {
            "title": 'Successfully declined the invite',
            "detail": "The team_invite record identified by id #{invite.id} was declined successfully."
          }
        }.with_indifferent_access
        expect(json).to eq(expected)
      end
    end

    context 'with a invalid or expired invite' do
      before do
        put bad_request,
            headers: {
              'Authorization': "Bearer #{token.token}",
              'Content-Type': 'application/vnd.api+json'
            },
            params: {
              accept: false
            }.to_json
      end

      it 'returns a error' do
        expected = {
          "errors": [
            {
              "title": 'Expired invite',
              "detail": 'This invite does not exist or has expired'
            }
          ]
        }.with_indifferent_access
        expect(json).to eq(expected)
      end
    end
  end
end
