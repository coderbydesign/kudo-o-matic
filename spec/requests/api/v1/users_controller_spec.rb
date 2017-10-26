require 'rails_helper'
require 'shared/api/v1/shared_expectations'

RSpec.describe Api::V1::UsersController, type: :request do
  include RequestHelpers

  describe 'GET api/v1/users/:id' do
    let (:request) {"/api/v1/users/#{user.id}"}
    let! (:user) {create(:user, :api_token)}
    let! (:record_count_before_request) {User.count}

    context 'with a valid api-token' do
      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      expect_user_count_same

      it 'returns the user associated with the id' do
        expected =
            {
                data: {
                    id: user.id.to_s,
                    type: 'users',
                    links: {
                        self: "http://www.example.com#{request}"
                    },
                    attributes: {
                        'created-at': to_api_timestamp_format(user.created_at),
                        'updated-at': to_api_timestamp_format(user.updated_at),
                        name: user.name,
                        email: user.email,
                        'avatar-url': user.avatar_url,
                        admin: user.admin
                    },
                    relationships: {
                        'sent-transactions': {
                            links: {
                                self: "http://www.example.com#{request}/relationships/sent-transactions",
                                related: "http://www.example.com#{request}/sent-transactions"
                            }
                        },
                        'received-transactions': {
                            links: {
                                self: "http://www.example.com#{request}/relationships/received-transactions",
                                related: "http://www.example.com#{request}/received-transactions"
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
        get request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_user_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_user_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end
end
