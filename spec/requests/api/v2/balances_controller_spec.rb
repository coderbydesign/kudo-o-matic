# frozen_string_literal: true

require 'rails_helper'
require 'shared/api/v1/shared_expectations'

RSpec.describe Api::V2::BalancesController, type: :request do
  include RequestHelpers

  describe 'GET api/v2/balances/:id' do
    let(:application) { create(:application) }
    let(:user) { create(:user) }
    let(:token) do
      Doorkeeper::AccessToken.create! application_id: application.id,
                                      resource_owner_id: user.id
    end
    let(:request) { "/api/v2/balances/#{balance.id}" }
    let!(:balance) { create(:balance, :current) }
    let!(:record_count_before_request) { Balance.count }

    context 'with a valid api-token' do
      before do
        get request, format: :json, access_token: token.token
      end

      expect_balance_count_same

      it 'returns the balance associated with the id' do
        expected =
          {
            data: {
              id: balance.id.to_s,
              type: 'balances',
              links: {
                self: "http://www.example.com#{request}"
              },
              attributes: {
                'created-at': to_api_timestamp_format(balance.created_at),
                'updated-at': to_api_timestamp_format(balance.updated_at),
                name: balance.name,
                current: balance.current,
                amount: balance.amount
              },
              relationships: {
                transactions: {
                  links: {
                    self: "http://www.example.com#{request}/relationships/transactions",
                    related: "http://www.example.com#{request}/transactions"
                  }
                }
              }
            }
          }.with_indifferent_access

        expect(json).to eq(expected)
      end

      expect_status_200_ok
    end

    context 'with an invalid api-token' do
      before do
        get request, format: :json, access_token: 'Invalid token'
      end

      expect_balance_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_balance_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end
end
