require 'rails_helper'
require 'shared/api/v1/shared_expectations'

def expect_record_count_same
  it 'does not change the record count' do
    expect(record_count_before_request).to be == User.count
  end
end

def expect_record_count_increase
  it 'increases the record count' do
    expect(record_count_before_request).to be < User.count
  end
end

def expect_record_count_decrease
  it 'decreases the record count' do
    expect(record_count_before_request).to be > User.count
  end
end

RSpec.describe Api::V1::UsersController, type: :request do
  include RequestHelpers

  describe 'GET api/v1/users' do
    let (:request) {'/api/v1/users'}
    let! (:user1) {create(:user)}

    context 'with a valid api-token' do
      let! (:user2) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}
      let! (:record_count_before_request) {User.count}

      before do
        get request, headers: {'Api-Token': user2.api_token}
      end

      expect_record_count_same

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
                            },
                            votes: {
                                links: {
                                    self: "http://www.example.com#{request}/#{user1.id}/relationships/votes",
                                    related: "http://www.example.com#{request}/#{user1.id}/votes"
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
                            },
                            votes: {
                                links: {
                                    self: "http://www.example.com#{request}/#{user2.id}/relationships/votes",
                                    related: "http://www.example.com#{request}/#{user2.id}/votes"
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
      let! (:record_count_before_request) {User.count}

      before do
        get request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let! (:record_count_before_request) {User.count}

      before do
        get request
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'GET api/v1/users/:id' do
    let (:request) {"/api/v1/users/#{user.id}"}
    let! (:user) {create(:user)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}
      let! (:record_count_before_request) {User.count}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      expect_record_count_same

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
                        },
                        votes: {
                            links: {
                                self: "http://www.example.com#{request}/relationships/votes",
                                related: "http://www.example.com#{request}/votes"
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
      let! (:record_count_before_request) {User.count}

      before do
        get request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let! (:record_count_before_request) {User.count}

      before do
        get request
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'POST api/v1/users' do
    let (:request) {'/api/v1/users'}
    let! (:user) {build(:user)}
    let! (:record_count_before_request) {User.count}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}
      let! (:record_count_before_request) {User.count}

      before do
        post request,
             headers: {
                 'Api-Token': user.api_token,
                 'Content-Type': 'application/vnd.api+json'
             },
             params: {
                 data: {
                     type: 'users',
                     attributes: {
                         name: user.name,
                         email: user.email,
                         'avatar-url': user.avatar_url,
                         admin: user.admin
                     }
                 }
             }.to_json
      end

      it 'persists the created user' do
        new_user = User.find(assigned_id)

        expect(new_user.name).to eq(user.name)
        expect(new_user.email).to eq(user.email)
        expect(new_user.avatar_url).to eq(user.avatar_url)
        expect(new_user.admin).to eq(user.admin)
      end

      expect_record_count_increase

      it 'returns the created user' do
        expected =
            {
                data: {
                    id: assigned_id,
                    type: 'users',
                    links: {
                        self: "http://www.example.com#{request}/#{assigned_id}"
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
                                self: "http://www.example.com#{request}/#{assigned_id}/relationships/sent-transactions",
                                related: "http://www.example.com#{request}/#{assigned_id}/sent-transactions"
                            }
                        },
                        'received-transactions': {
                            links: {
                                self: "http://www.example.com#{request}/#{assigned_id}/relationships/received-transactions",
                                related: "http://www.example.com#{request}/#{assigned_id}/received-transactions"
                            }
                        },
                        votes: {
                            links: {
                                self: "http://www.example.com#{request}/#{assigned_id}/relationships/votes",
                                related: "http://www.example.com#{request}/#{assigned_id}/votes"
                            }
                        }
                    }
                }
            }.with_indifferent_access

        expect(json).to eq(expected)
      end

      expect_status_201_created
    end

    context 'with an invalid api-token' do
      let! (:record_count_before_request) {User.count}

      before do
        post request,
             headers: {
                 'Api-Token': 'invalid api-token',
                 'Content-Type': 'application/vnd.api+json'
             },
             params: {
                 data: {
                     type: 'users',
                     attributes: {
                         name: user.name,
                         email: user.email,
                         'avatar-url': user.avatar_url,
                         admin: user.admin
                     }
                 }
             }.to_json
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let! (:record_count_before_request) {User.count}

      before do
        post request,
             headers: {
                 'Content-Type': 'application/vnd.api+json'
             },
             params: {
                 data: {
                     type: 'users',
                     attributes: {
                         name: user.name,
                         email: user.email,
                         'avatar-url': user.avatar_url,
                         admin: user.admin
                     }
                 }
             }.to_json
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
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
        let! (:record_count_before_request) {User.count}

        before do
          patch request,
                headers: {
                    'Api-Token': user.api_token,
                    'Content-Type': 'application/vnd.api+json'
                },
                params: {
                    data: {
                        type: 'users',
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

        it 'persists the updated user associated with the id with updated values' do
          updated_user = User.find(user.id)

          expect(updated_user.name).to eq(edited_name)
          expect(updated_user.email).to eq(edited_email)
          expect(updated_user.avatar_url).to eq(edited_avatar_url)
          expect(updated_user.admin).to eq(edited_admin)
        end

        expect_record_count_same

        it 'returns the updated user associated with the id with updated values' do
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
                          'updated-at': assigned_updated_at,
                          name: edited_name,
                          email: edited_email,
                          'avatar-url': edited_avatar_url,
                          admin: edited_admin
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
                          },
                          votes: {
                              links: {
                                  self: "http://www.example.com#{request}/relationships/votes",
                                  related: "http://www.example.com#{request}/votes"
                              }
                          }
                      }
                  }
              }.with_indifferent_access

          expect(json).to eq(expected)
        end

        expect_status_200_ok
      end

      context 'and without updated values' do
        let! (:record_count_before_request) {User.count}

        before do
          patch request,
                headers: {'Api-Token': user.api_token, 'Content-Type': 'application/vnd.api+json'},
                params: {data: {type: 'users', id: user.id}}.to_json
        end

        it 'persists the user user associated with the id without updated values' do
          updated_user = User.find(user.id)

          expect(updated_user.name).to eq(user.name)
          expect(updated_user.email).to eq(user.email)
          expect(updated_user.avatar_url).to eq(user.avatar_url)
          expect(updated_user.admin).to eq(user.admin)
        end

        expect_record_count_same

        it 'returns the updated user associated with the id without updated values' do
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
                          },
                          votes: {
                              links: {
                                  self: "http://www.example.com#{request}/relationships/votes",
                                  related: "http://www.example.com#{request}/votes"
                              }
                          }
                      }
                  }
              }.with_indifferent_access

          expect(json).to eq(expected)
        end

        expect_status_200_ok
      end
    end

    context 'with an invalid api-token' do
      let! (:record_count_before_request) {User.count}

      before do
        patch request,
              headers: {
                  'Api-Token': 'invalid api-token',
                  'Content-Type': 'application/vnd.api+json'
              },
              params: {
                  data: {
                      type: 'users',
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

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let! (:record_count_before_request) {User.count}

      before do
        patch request,
              headers: {
                  'Content-Type': 'application/vnd.api+json'
              },
              params: {
                  data: {
                      type: 'users',
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

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'DELETE api/v1/users/:id' do
    let (:request) {"/api/v1/users/#{user.id}"}
    let! (:administrator) {create(:user, :admin)} # deleting a user requires at least one administrator in the system
    let! (:user) {create(:user)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}
      let! (:record_count_before_request) {User.count}

      before do
        delete request, headers: {'Api-Token': user.api_token}
      end

      it 'deletes the user associated with the id' do
        expect {User.find(user.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end

      expect_record_count_decrease

      expect_status_204_no_content
    end

    context 'with an invalid api-token' do
      let! (:record_count_before_request) {User.count}

      before do
        delete request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let! (:record_count_before_request) {User.count}

      before do
        delete request
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end
end
