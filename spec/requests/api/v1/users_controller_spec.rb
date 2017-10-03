require 'rails_helper'
require 'shared/api/v1/unauthorized'

RSpec.describe Api::V1::UsersController, type: :request do
  include RequestHelpers

  let (:host) {'http://www.example.com'}
  let (:resource_type) {'users'}
  let (:relationship_type_sent_transactions) {'sent-transactions'}
  let (:relationship_type_received_transactions) {'received-transactions'}

  describe 'GET api/v1/users' do
    let (:request) {'/api/v1/users'}
    let! (:user1) {create(:user)}

    context 'with a valid api-token' do
      let (:user2) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      before do
        get request, headers: {'Api-Token': user2.api_token}
      end

      it 'returns all users' do
        expected =
            {
                data: [
                    {
                        id: user1.id.to_s,
                        type: resource_type,
                        links: {
                            self: "#{host}#{request}/#{user1.id}"
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
                                    self: "#{host}#{request}/#{user1.id}/relationships/#{relationship_type_sent_transactions}",
                                    related: "#{host}#{request}/#{user1.id}/#{relationship_type_sent_transactions}"
                                }
                            },
                            'received-transactions': {
                                links: {
                                    self: "#{host}#{request}/#{user1.id}/relationships/#{relationship_type_received_transactions}",
                                    related: "#{host}#{request}/#{user1.id}/#{relationship_type_received_transactions}"
                                }
                            }
                        }
                    },
                    {
                        id: user2.id.to_s,
                        type: resource_type,
                        links: {
                            self: "#{host}#{request}/#{user2.id}"
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
                                    self: "#{host}#{request}/#{user2.id}/relationships/#{relationship_type_sent_transactions}",
                                    related: "#{host}#{request}/#{user2.id}/#{relationship_type_sent_transactions}"
                                }
                            },
                            'received-transactions': {
                                links: {
                                    self: "#{host}#{request}/#{user2.id}/relationships/#{relationship_type_received_transactions}",
                                    related: "#{host}#{request}/#{user2.id}/#{relationship_type_received_transactions}"
                                }
                            }
                        }
                    }
                ]
            }.with_indifferent_access

        expect(json).to eq(expected)
      end

      it 'returns a 200 (ok) status code' do
        expect(response).to have_http_status(200)
      end
    end

    context 'with an invalid api-token' do
      before do
        get request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_unauthorized_message_and_status_code
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_unauthorized_message_and_status_code
    end
  end

  describe 'GET api/v1/users/:id' do
    let (:request) {"/api/v1/users/#{user.id}"}
    let! (:user) {create(:user)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      it 'returns the user associated with the id' do
        expected =
            {
                data: {
                    id: user.id.to_s,
                    type: resource_type,
                    links: {
                        self: "#{host}#{request}"
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
                                self: "#{host}#{request}/relationships/#{relationship_type_sent_transactions}",
                                related: "#{host}#{request}/#{relationship_type_sent_transactions}"
                            }
                        },
                        'received-transactions': {
                            links: {
                                self: "#{host}#{request}/relationships/#{relationship_type_received_transactions}",
                                related: "#{host}#{request}/#{relationship_type_received_transactions}"
                            }
                        }
                    }
                }
            }.with_indifferent_access

        expect(json).to eq(expected)
      end

      it 'returns a 200 (ok) status code' do
        expect(response).to have_http_status(200)
      end
    end

    context 'with an invalid api-token' do
      before do
        get request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_unauthorized_message_and_status_code
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_unauthorized_message_and_status_code
    end
  end

  describe 'POST api/v1/users' do
    let (:request) {'/api/v1/users'}
    let! (:user) {build(:user)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      before do
        post request,
             headers: {
                 'Api-Token': user.api_token,
                 'Content-Type': 'application/vnd.api+json'
             },
             params: {
                 data: {
                     type: resource_type,
                     attributes: {
                         name: user.name,
                         email: user.email,
                         'avatar-url': user.avatar_url,
                         admin: user.admin
                     }
                 }
             }.to_json
      end

      it 'returns the newly created user' do
        expected =
            {
                data: {
                    id: assigned_id,
                    type: resource_type,
                    links: {
                        self: "#{host}#{request}/#{assigned_id}"
                    },
                    attributes: {
                        'created-at': assigned_created_at,
                        'updated-at': assigned_updated_at,
                        name: user.name,
                        email: user.email,
                        'avatar-url': user.avatar_url,
                        admin: user.admin
                    },
                    relationships: {
                        'sent-transactions': {
                            links: {
                                self: "#{host}#{request}/#{assigned_id}/relationships/#{relationship_type_sent_transactions}",
                                related: "#{host}#{request}/#{assigned_id}/#{relationship_type_sent_transactions}"
                            }
                        },
                        'received-transactions': {
                            links: {
                                self: "#{host}#{request}/#{assigned_id}/relationships/#{relationship_type_received_transactions}",
                                related: "#{host}#{request}/#{assigned_id}/#{relationship_type_received_transactions}"
                            }
                        }
                    }
                }
            }.with_indifferent_access

        expect(json).to eq(expected)
      end

      it 'persists the newly created user' do
        new_user = User.find(assigned_id)

        expect(new_user.name).to eq(user.name)
        expect(new_user.email).to eq(user.email)
        expect(new_user.avatar_url).to eq(user.avatar_url)
        expect(new_user.admin).to eq(user.admin)
      end

      it 'returns a 201 (created) status code' do
        expect(response).to have_http_status(201)
      end
    end

    context 'with an invalid api-token' do
      before do
        post request,
             headers: {
                 'Api-Token': 'invalid api-token',
                 'Content-Type': 'application/vnd.api+json'
             },
             params: {
                 data: {
                     type: resource_type,
                     attributes: {
                         name: user.name,
                         email: user.email,
                         'avatar-url': user.avatar_url,
                         admin: user.admin
                     }
                 }
             }.to_json
      end

      expect_unauthorized_message_and_status_code
    end

    context 'without an api-token' do
      before do
        post request,
             headers: {
                 'Content-Type': 'application/vnd.api+json'
             },
             params: {
                 data: {
                     type: resource_type,
                     attributes: {
                         name: user.name,
                         email: user.email,
                         'avatar-url': user.avatar_url,
                         admin: user.admin
                     }
                 }
             }.to_json
      end

      expect_unauthorized_message_and_status_code
    end
  end

  describe 'PATCH api/v1/users/:id' do
    let (:request) {"/api/v1/users/#{user.id}"}
    let! (:user) {create(:user)}
    let(:edited_name) {'edited name'}
    let(:edited_email) {'edited email'}
    let(:edited_avatar_url) {'edited avatar url'}
    let(:edited_admin) {true}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      context 'and updated values' do
        before do
          patch request,
                headers: {
                    'Api-Token': user.api_token,
                    'Content-Type': 'application/vnd.api+json'
                },
                params: {
                    data: {
                        type: resource_type,
                        id: user.id,
                        attributes: {
                            name: edited_name,
                            email: edited_email,
                            'avatar-url': edited_avatar_url,
                            admin: edited_admin
                        }
                    }
                }.to_json
        end

        it 'returns the updated user associated with the id with updated values' do
          expected =
              {
                  data: {
                      id: user.id.to_s,
                      type: resource_type,
                      links: {
                          self: "#{host}#{request}"
                      },
                      attributes: {
                          'created-at': to_api_timestamp_format(user.created_at),
                          'updated-at': assigned_updated_at,
                          name: edited_name,
                          email: edited_email,
                          'avatar-url': edited_avatar_url,
                          admin: edited_admin
                      },
                      relationships: {
                          'sent-transactions': {
                              links: {
                                  self: "#{host}#{request}/relationships/#{relationship_type_sent_transactions}",
                                  related: "#{host}#{request}/#{relationship_type_sent_transactions}"
                              }
                          },
                          'received-transactions': {
                              links: {
                                  self: "#{host}#{request}/relationships/#{relationship_type_received_transactions}",
                                  related: "#{host}#{request}/#{relationship_type_received_transactions}"
                              }
                          }
                      }
                  }
              }.with_indifferent_access

          expect(json).to eq(expected)
        end

        it 'persists the updated user with updated values' do
          updated_user = User.find(user.id)

          expect(updated_user.name).to eq(edited_name)
          expect(updated_user.email).to eq(edited_email)
          expect(updated_user.avatar_url).to eq(edited_avatar_url)
          expect(updated_user.admin).to eq(edited_admin)
        end

        it 'returns a 200 (ok) status code' do
          expect(response).to have_http_status(200)
        end
      end

      context 'and without updated values' do
        before do
          patch request,
                headers: {'Api-Token': user.api_token, 'Content-Type': 'application/vnd.api+json'},
                params: {data: {type: resource_type, id: user.id}}.to_json
        end

        it 'returns the updated user associated with the id without updated values' do
          expected =
              {
                  data: {
                      id: user.id.to_s,
                      type: resource_type,
                      links: {
                          self: "#{host}#{request}"
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
                                  self: "#{host}#{request}/relationships/#{relationship_type_sent_transactions}",
                                  related: "#{host}#{request}/#{relationship_type_sent_transactions}"
                              }
                          },
                          'received-transactions': {
                              links: {
                                  self: "#{host}#{request}/relationships/#{relationship_type_received_transactions}",
                                  related: "#{host}#{request}/#{relationship_type_received_transactions}"
                              }
                          }
                      }
                  }
              }.with_indifferent_access

          expect(json).to eq(expected)
        end

        it 'persists the user user without updated values' do
          updated_user = User.find(user.id)

          expect(updated_user.name).to eq(user.name)
          expect(updated_user.email).to eq(user.email)
          expect(updated_user.avatar_url).to eq(user.avatar_url)
          expect(updated_user.admin).to eq(user.admin)
        end

        it 'returns a 200 (ok) status code' do
          expect(response).to have_http_status(200)
        end
      end
    end

    context 'with an invalid api-token' do
      before do
        patch request,
              headers: {
                  'Api-Token': 'invalid api-token',
                  'Content-Type': 'application/vnd.api+json'
              },
              params: {
                  data: {
                      type: resource_type,
                      id: user.id,
                      attributes: {
                          name: edited_name,
                          email: edited_email,
                          'avatar-url': edited_avatar_url,
                          admin: edited_admin
                      }
                  }
              }.to_json
      end

      expect_unauthorized_message_and_status_code
    end

    context 'without an api-token' do
      before do
        patch request,
              headers: {
                  'Content-Type': 'application/vnd.api+json'
              },
              params: {
                  data: {
                      type: resource_type,
                      id: user.id,
                      attributes: {
                          name: edited_name,
                          email: edited_email,
                          'avatar-url': edited_avatar_url,
                          admin: edited_admin
                      }
                  }
              }.to_json
      end

      expect_unauthorized_message_and_status_code
    end
  end

  describe 'DELETE api/v1/users/:id' do
    let (:request) {"/api/v1/users/#{user.id}"}
    let! (:user) {create(:user)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      before do
        delete request, headers: {'Api-Token': user.api_token}
      end

      it 'deletes the user associated with the id' do
        expect {User.find(user.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'returns a 204 (no content) status code' do
        expect(response).to have_http_status(204)
      end
    end

    context 'with an invalid api-token' do
      before do
        delete request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_unauthorized_message_and_status_code
    end

    context 'without an api-token' do
      before do
        delete request
      end

      expect_unauthorized_message_and_status_code
    end
  end
end
