require 'rails_helper'
require 'shared/api/v1/shared_expectations'

RSpec.describe Api::V1::UsersController, type: :request do
  include RequestHelpers

  describe 'GET api/v1/users' do
    let (:request) {'/api/v1/users'}
    let! (:user1) {create(:user, :api_token)}
    let! (:user2) {create(:user)}
    let! (:record_count_before_request) {User.count}

    context 'with a valid api-token' do
      before do
        get request, headers: {'Api-Token': user1.api_token}
      end

      expect_user_count_same

      it 'returns all users' do
        expected =
            {
                data: [
                    {
                        id: user1.id.to_s,
                        type: 'users',
                        links: {
                            self: "http://www.example.com#{request}/#{user1.id}"
                        },
                        attributes: {
                            'created-at': to_api_timestamp_format(user1.created_at),
                            'updated-at': to_api_timestamp_format(user1.updated_at),
                            name: user1.name,
                            email: user1.email,
                            'avatar-url': user1.avatar_url,
                            admin: user1.admin
                        },
                        relationships: {
                            'sent-transactions': {
                                links: {
                                    self: "http://www.example.com#{request}/#{user1.id}/relationships/sent-transactions",
                                    related: "http://www.example.com#{request}/#{user1.id}/sent-transactions"
                                }
                            },
                            'received-transactions': {
                                links: {
                                    self: "http://www.example.com#{request}/#{user1.id}/relationships/received-transactions",
                                    related: "http://www.example.com#{request}/#{user1.id}/received-transactions"
                                }
                            }
                        }
                    },
                    {
                        id: user2.id.to_s,
                        type: 'users',
                        links: {
                            self: "http://www.example.com#{request}/#{user2.id}"
                        },
                        attributes: {
                            'created-at': to_api_timestamp_format(user2.created_at),
                            'updated-at': to_api_timestamp_format(user2.updated_at),
                            name: user2.name,
                            email: user2.email,
                            'avatar-url': user2.avatar_url,
                            admin: user2.admin
                        },
                        relationships: {
                            'sent-transactions': {
                                links: {
                                    self: "http://www.example.com#{request}/#{user2.id}/relationships/sent-transactions",
                                    related: "http://www.example.com#{request}/#{user2.id}/sent-transactions"
                                }
                            },
                            'received-transactions': {
                                links: {
                                    self: "http://www.example.com#{request}/#{user2.id}/relationships/received-transactions",
                                    related: "http://www.example.com#{request}/#{user2.id}/received-transactions"
                                }
                            }
                        }
                    }
                ]
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
