require 'rails_helper'
require 'shared/api/v1/shared_expectations'
require 'base64'

RSpec.describe Api::V1::TransactionsController, type: :request do
  include RequestHelpers

  describe 'GET api/v1/transactions' do
    let (:request) {'/api/v1/transactions'}
    let! (:transaction1) {create(:transaction, :image)}
    let! (:transaction2) {create(:transaction)}
    let! (:record_count_before_request) {Transaction.count}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      expect_transaction_count_same

      it 'returns all transactions' do
        expected =
            {
                data: [
                    {
                        id: transaction1.id.to_s,
                        type: 'transactions',
                        links: {
                            self: "http://www.example.com#{request}/#{transaction1.id}"
                        },
                        attributes: {
                            'created-at': to_api_timestamp_format(transaction1.created_at),
                            'updated-at': to_api_timestamp_format(transaction1.updated_at),
                            amount: transaction1.amount,
                            activity: transaction1.activity.name,
                            'votes-count': transaction1.likes_amount,
                            'api-user-voted': (user.voted_on? transaction1),
                            'image-url-original': transaction1.image.url,
                            'image-url-thumb': transaction1.image.url(:thumb),
                            'image-file-name': transaction1.image_file_name,
                            'image-content-type': transaction1.image_content_type,
                            'image-file-size': transaction1.image_file_size,
                            'image-updated-at': to_api_timestamp_format(transaction1.image_updated_at)
                        },
                        relationships: {
                            sender: {
                                links: {
                                    self: "http://www.example.com#{request}/#{transaction1.id}/relationships/sender",
                                    related: "http://www.example.com#{request}/#{transaction1.id}/sender"
                                }
                            },
                            receiver: {
                                links: {
                                    self: "http://www.example.com#{request}/#{transaction1.id}/relationships/receiver",
                                    related: "http://www.example.com#{request}/#{transaction1.id}/receiver"
                                }
                            },
                            balance: {
                                links: {
                                    self: "http://www.example.com#{request}/#{transaction1.id}/relationships/balance",
                                    related: "http://www.example.com#{request}/#{transaction1.id}/balance"
                                }
                            }
                        }
                    },
                    {
                        id: transaction2.id.to_s,
                        type: 'transactions',
                        links: {
                            self: "http://www.example.com#{request}/#{transaction2.id}"
                        },
                        attributes: {
                            'created-at': to_api_timestamp_format(transaction2.created_at),
                            'updated-at': to_api_timestamp_format(transaction2.updated_at),
                            amount: transaction2.amount,
                            activity: transaction2.activity.name,
                            'votes-count': transaction2.likes_amount,
                            'api-user-voted': (user.voted_on? transaction2),
                            'image-url-original': nil,
                            'image-url-thumb': nil,
                            'image-file-name': nil,
                            'image-content-type': nil,
                            'image-file-size': nil,
                            'image-updated-at': nil
                        },
                        relationships: {
                            sender: {
                                links: {
                                    self: "http://www.example.com#{request}/#{transaction2.id}/relationships/sender",
                                    related: "http://www.example.com#{request}/#{transaction2.id}/sender"
                                }
                            },
                            receiver: {
                                links: {
                                    self: "http://www.example.com#{request}/#{transaction2.id}/relationships/receiver",
                                    related: "http://www.example.com#{request}/#{transaction2.id}/receiver"
                                }
                            },
                            balance: {
                                links: {
                                    self: "http://www.example.com#{request}/#{transaction2.id}/relationships/balance",
                                    related: "http://www.example.com#{request}/#{transaction2.id}/balance"
                                }
                            }
                        }
                    }
                ],
                links: {
                    first: "http://www.example.com#{request}?page%5Blimit%5D=10&page%5Boffset%5D=0",
                    last: "http://www.example.com#{request}?page%5Blimit%5D=10&page%5Boffset%5D=0"
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

      expect_transaction_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_transaction_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'GET api/v1/transactions?page[limit]=:limit&page[offset]=:offset' do
    let (:request) {'/api/v1/transactions?page[limit]=1&page[offset]=2'}
    let! (:transaction1) {create(:transaction)}
    let! (:transaction2) {create(:transaction)}
    let! (:transaction3) {create(:transaction)}
    let! (:transaction4) {create(:transaction)}
    let! (:transaction5) {create(:transaction)}
    let! (:record_count_before_request) {Transaction.count}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      expect_transaction_count_same

      it 'returns a paginated collection of transactions' do
        expected =
            {
                data: [
                    {
                        id: transaction3.id.to_s,
                        type: 'transactions',
                        links: {
                            self: "http://www.example.com/api/v1/transactions/#{transaction3.id}"
                        },
                        attributes: {
                            'created-at': to_api_timestamp_format(transaction3.created_at),
                            'updated-at': to_api_timestamp_format(transaction3.updated_at),
                            amount: transaction3.amount,
                            activity: transaction3.activity.name,
                            'votes-count': transaction3.likes_amount,
                            'api-user-voted': (user.voted_on? transaction3),
                            'image-url-original': nil,
                            'image-url-thumb': nil,
                            'image-file-name': nil,
                            'image-content-type': nil,
                            'image-file-size': nil,
                            'image-updated-at': nil
                        },
                        relationships: {
                            sender: {
                                links: {
                                    self: "http://www.example.com/api/v1/transactions/#{transaction3.id}/relationships/sender",
                                    related: "http://www.example.com/api/v1/transactions/#{transaction3.id}/sender"
                                }
                            },
                            receiver: {
                                links: {
                                    self: "http://www.example.com/api/v1/transactions/#{transaction3.id}/relationships/receiver",
                                    related: "http://www.example.com/api/v1/transactions/#{transaction3.id}/receiver"
                                }
                            },
                            balance: {
                                links: {
                                    self: "http://www.example.com/api/v1/transactions/#{transaction3.id}/relationships/balance",
                                    related: "http://www.example.com/api/v1/transactions/#{transaction3.id}/balance"
                                }
                            }
                        }
                    }
                ],
                links: {
                    first: "http://www.example.com/api/v1/transactions?page%5Blimit%5D=1&page%5Boffset%5D=0",
                    prev: "http://www.example.com/api/v1/transactions?page%5Blimit%5D=1&page%5Boffset%5D=1",
                    next: "http://www.example.com/api/v1/transactions?page%5Blimit%5D=1&page%5Boffset%5D=3",
                    last: "http://www.example.com/api/v1/transactions?page%5Blimit%5D=1&page%5Boffset%5D=4"
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

      expect_transaction_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_transaction_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'GET api/v1/transactions/:id' do
    let (:request) {"/api/v1/transactions/#{transaction.id}"}
    let! (:transaction) {create(:transaction, :image)}
    let! (:record_count_before_request) {Transaction.count}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      expect_transaction_count_same

      it 'returns the transaction associated with the id' do
        expected =
            {
                data: {
                    id: transaction.id.to_s,
                    type: 'transactions',
                    links: {
                        self: "http://www.example.com#{request}"
                    },
                    attributes: {
                        'created-at': to_api_timestamp_format(transaction.created_at),
                        'updated-at': to_api_timestamp_format(transaction.updated_at),
                        amount: transaction.amount,
                        activity: transaction.activity.name,
                        'votes-count': transaction.likes_amount,
                        'api-user-voted': (user.voted_on? transaction),
                        'image-url-original': transaction.image.url,
                        'image-url-thumb': transaction.image.url(:thumb),
                        'image-file-name': transaction.image_file_name,
                        'image-content-type': transaction.image_content_type,
                        'image-file-size': transaction.image_file_size,
                        'image-updated-at': to_api_timestamp_format(transaction.image_updated_at)
                    },
                    relationships: {
                        sender: {
                            links: {
                                self: "http://www.example.com#{request}/relationships/sender",
                                related: "http://www.example.com#{request}/sender"
                            }
                        },
                        receiver: {
                            links: {
                                self: "http://www.example.com#{request}/relationships/receiver",
                                related: "http://www.example.com#{request}/receiver"
                            }
                        },
                        balance: {
                            links: {
                                self: "http://www.example.com#{request}/relationships/balance",
                                related: "http://www.example.com#{request}/balance"
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

      expect_transaction_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_transaction_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'POST api/v1/transactions' do
    let (:request) {"/api/v1/transactions"}
    let! (:transaction) {build(:transaction)}
    let! (:sender) {create(:user, :api_token)}
    let! (:receiver) {create(:user, name: 'Receiver')}
    let! (:balance) {create(:balance, :current)}
    let! (:record_count_before_request) {Transaction.count}

    context 'with a valid api-token' do
      context 'and an image attachment' do
        before do
          post request,
               headers: {
                   'Api-Token': sender.api_token,
                   'Content-Type': 'application/vnd.api+json'
               },
               params: {
                   data: {
                       type: 'transactions',
                       attributes: {
                           amount: transaction.amount,
                           activity: transaction.activity.name,
                           image: Base64.encode64(File.open(Rails.root + 'spec/fixtures/images/rails.png') {|io| io.read}),
                           'image-file-type': 'png'
                       },
                       relationships: {
                           receiver: {
                               data: {
                                   type: 'users',
                                   name: receiver.name
                               }
                           }
                       }
                   }
               }.to_json
        end

        it 'persists the created transaction with an image attachment' do
          new_transaction = Transaction.find(assigned_id)

          expect(new_transaction.amount).to eq(transaction.amount)
        end

        expect_transaction_count_increase

        it 'returns the created transaction' do
          expected =
              {
                  data: {
                      id: assigned_id,
                      type: 'transactions',
                      links: {
                          self: "http://www.example.com#{request}/#{assigned_id}"
                      },
                      attributes: {
                          'created-at': assigned_created_at,
                          'updated-at': assigned_updated_at,
                          amount: transaction.amount,
                          activity: transaction.activity.name,
                          'votes-count': transaction.likes_amount,
                          'api-user-voted': (sender.voted_on? transaction),
                          'image-url-original': json['data']['attributes']['image-url-original'],
                          'image-url-thumb': json['data']['attributes']['image-url-thumb'],
                          'image-file-name': 'image.png',
                          'image-content-type': 'image/png',
                          'image-file-size': json['data']['attributes']['image-file-size'],
                          'image-updated-at': json['data']['attributes']['image-updated-at']
                      },
                      relationships: {
                          sender: {
                              links: {
                                  self: "http://www.example.com/api/v1/transactions/#{assigned_id}/relationships/sender",
                                  related: "http://www.example.com/api/v1/transactions/#{assigned_id}/sender"
                              }
                          },
                          receiver: {
                              links: {
                                  self: "http://www.example.com/api/v1/transactions/#{assigned_id}/relationships/receiver",
                                  related: "http://www.example.com/api/v1/transactions/#{assigned_id}/receiver"
                              }
                          },
                          balance: {
                              links: {
                                  self: "http://www.example.com/api/v1/transactions/#{assigned_id}/relationships/balance",
                                  related: "http://www.example.com/api/v1/transactions/#{assigned_id}/balance"
                              }
                          }
                      }
                  }
              }.with_indifferent_access

          expect(json).to eq(expected)
        end

        expect_status_201_created
      end

      context 'and without an image attachment' do
        before do
          post request,
               headers: {
                   'Api-Token': sender.api_token,
                   'Content-Type': 'application/vnd.api+json'
               },
               params: {
                   data: {
                       type: 'transactions',
                       attributes: {
                           amount: transaction.amount,
                           activity: transaction.activity.name
                       },
                       relationships: {
                           receiver: {
                               data: {
                                   type: 'users',
                                   name: receiver.name
                               }
                           }
                       }
                   }
               }.to_json
        end

        it 'persists the created transaction without an image attachment' do
          new_transaction = Transaction.find(assigned_id)

          expect(new_transaction.amount).to eq(transaction.amount)
        end

        expect_transaction_count_increase

        it 'returns the created transaction' do
          expected =
              {
                  data: {
                      id: assigned_id,
                      type: 'transactions',
                      links: {
                          self: "http://www.example.com#{request}/#{assigned_id}"
                      },
                      attributes: {
                          'created-at': assigned_created_at,
                          'updated-at': assigned_updated_at,
                          amount: transaction.amount,
                          activity: transaction.activity.name,
                          'votes-count': transaction.likes_amount,
                          'api-user-voted': (sender.voted_on? transaction),
                          'image-url-original': nil,
                          'image-url-thumb': nil,
                          'image-file-name': nil,
                          'image-content-type': nil,
                          'image-file-size': nil,
                          'image-updated-at': nil
                      },
                      relationships: {
                          sender: {
                              links: {
                                  self: "http://www.example.com/api/v1/transactions/#{assigned_id}/relationships/sender",
                                  related: "http://www.example.com/api/v1/transactions/#{assigned_id}/sender"
                              }
                          },
                          receiver: {
                              links: {
                                  self: "http://www.example.com/api/v1/transactions/#{assigned_id}/relationships/receiver",
                                  related: "http://www.example.com/api/v1/transactions/#{assigned_id}/receiver"
                              }
                          },
                          balance: {
                              links: {
                                  self: "http://www.example.com/api/v1/transactions/#{assigned_id}/relationships/balance",
                                  related: "http://www.example.com/api/v1/transactions/#{assigned_id}/balance"
                              }
                          }
                      }
                  }
              }.with_indifferent_access

          expect(json).to eq(expected)
        end

        expect_status_201_created
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
                     type: 'transactions',
                     attributes: {
                         amount: transaction.amount,
                         activity: transaction.activity.name
                     },
                     relationships: {
                         receiver: {
                             data: {
                                 type: 'users',
                                 name: receiver.name
                             }
                         }
                     }
                 }
             }.to_json
      end

      expect_transaction_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        post request,
             headers: {
                 'Content-Type': 'application/vnd.api+json'
             },
             params: {
                 data: {
                     data: {
                         type: 'transactions',
                         attributes: {
                             amount: transaction.amount,
                             activity: transaction.activity.name
                         },
                         relationships: {
                             receiver: {
                                 data: {
                                     type: 'users',
                                     name: receiver.name
                                 }
                             }
                         }
                     }
                 }
             }.to_json
      end

      expect_transaction_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'PUT api/v1/transactions/:id/like' do
    let! (:transaction) {create(:transaction)}
    let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}
    let (:default_vote_flag) {true}
    let (:default_vote_scope) {nil}
    let (:default_vote_weight) {1}
    let (:invalid_transaction_id) {-1}
    let (:invalid_user_id) {-1}

    context 'with a valid api-token' do
      context 'and a valid transaction id' do
        let (:request) {"/api/v1/transactions/#{transaction.id}/like"}
        let! (:record_count_before_request) {Vote.count}

        before do
          put request, headers: {'Api-Token': user.api_token}
        end

        it 'persists the vote' do
          created_vote = Vote.find_by(votable_id: transaction.id, voter_id: user.id)

          expect(created_vote.votable_type).to eq(transaction.class.name)
          expect(created_vote.votable_id).to eq(transaction.id)
          expect(created_vote.voter_type).to eq(user.class.name)
          expect(created_vote.voter_id).to eq(user.id)
          expect(created_vote.vote_flag).to eq(default_vote_flag)
          expect(created_vote.vote_scope).to eq(default_vote_scope)
          expect(created_vote.vote_weight).to eq(default_vote_weight)
        end

        expect_vote_count_increase

        it 'returns the successfully liked response' do
          expected =
              {
                  data: {
                      title: 'Successfully liked successfully',
                      detail: "The transaction record identified by id #{transaction.id} was liked successfully."
                  }
              }.with_indifferent_access

          expect(json).to eq(expected)
        end

        expect_status_200_ok
      end
      context 'an an invalid transaction id' do
        let (:request) {"/api/v1/transactions/#{invalid_transaction_id}/like"}
        let! (:record_count_before_request) {Vote.count}

        before do
          put request, headers: {'Api-Token': user.api_token}
        end

        expect_transaction_record_not_found_response

        expect_vote_count_same

        expect_status_404_not_found
      end
    end

    context 'with an invalid api-token' do
      let (:request) {"/api/v1/transactions/#{transaction.id}/like"}
      let! (:record_count_before_request) {Vote.count}

      before do
        put request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_vote_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let (:request) {"/api/v1/transactions/#{transaction.id}/like"}
      let! (:record_count_before_request) {Vote.count}

      before do
        put request
      end

      expect_vote_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'DELETE api/v1/transactions/:id/like' do
    let! (:transaction) {create(:transaction)}
    let! (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}
    let!(:vote) {
      create(:vote, votable_type: 'Transaction', votable_id: transaction.id, voter_type: 'User', voter_id: user.id)
    }
    let (:invalid_transaction_id) {-1}
    let (:invalid_user_id) {-1}

    context 'with a valid api-token' do
      context 'and a valid transaction id' do
        let (:request) {"/api/v1/transactions/#{transaction.id}/like"}
        let! (:record_count_before_request) {Vote.count}

        before do
          delete request, headers: {'Api-Token': user.api_token}
        end

        it "deletes the vote associated with the transaction and user id's" do
          expect {Vote.find(vote.id)}.to raise_error(ActiveRecord::RecordNotFound)
        end

        expect_vote_count_decrease

        it 'returns the successfully unliked response' do
          expected =
              {
                  data: {
                      title: 'Successfully unliked successfully',
                      detail: "The transaction record identified by id #{transaction.id} was unliked successfully."
                  }
              }.with_indifferent_access

          expect(json).to eq(expected)
        end

        expect_status_200_ok
      end

      context 'an an invalid transaction id' do
        let (:request) {"/api/v1/transactions/#{invalid_transaction_id}/like"}
        let! (:record_count_before_request) {Vote.count}

        before do
          delete request, headers: {'Api-Token': user.api_token}
        end

        expect_transaction_record_not_found_response

        expect_vote_count_same

        expect_status_404_not_found
      end
    end

    context 'with an invalid api-token' do
      let (:request) {"/api/v1/transactions/#{transaction.id}/like"}
      let! (:record_count_before_request) {Vote.count}

      before do
        delete request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_vote_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let (:request) {"/api/v1/transactions/#{transaction.id}/like"}
      let! (:record_count_before_request) {Vote.count}

      before do
        delete request
      end

      expect_vote_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end
end
