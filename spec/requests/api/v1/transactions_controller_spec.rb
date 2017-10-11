require 'rails_helper'
require 'shared/api/v1/shared_expectations'

def expect_transaction_record_count_same
  it 'does not change the transaction record count' do
    expect(record_count_before_request).to be == Transaction.count
  end
end

def expect_transaction_record_count_increase
  it 'increases the transaction record count' do
    expect(record_count_before_request).to be < Transaction.count
  end
end

def expect_transaction_record_count_decrease
  it 'decreases the transaction record count' do
    expect(record_count_before_request).to be > Transaction.count
  end
end

def expect_vote_record_count_same
  it 'does not change the vote record count' do
    expect(record_count_before_request).to be == Vote.count
  end
end

def expect_vote_record_count_increase
  it 'increases the vote record count' do
    expect(record_count_before_request).to be < Vote.count
  end
end

def expect_vote_record_count_decrease
  it 'decreases the vote record count' do
    expect(record_count_before_request).to be > Vote.count
  end
end

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

      expect_transaction_record_count_same

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
                            'image-url-original': transaction1.image.url,
                            'image-url-thumb': transaction1.image.url(:thumb),
                            'image-file-name': transaction1.image_file_name,
                            'image-content-type': transaction1.image_content_type,
                            'image-file-size': transaction1.image_file_size,
                            'image-updated-at': to_api_timestamp_format(transaction1.image_updated_at),
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
                            activity: {
                                links: {
                                    self: "http://www.example.com#{request}/#{transaction1.id}/relationships/activity",
                                    related: "http://www.example.com#{request}/#{transaction1.id}/activity"
                                }
                            },
                            balance: {
                                links: {
                                    self: "http://www.example.com#{request}/#{transaction1.id}/relationships/balance",
                                    related: "http://www.example.com#{request}/#{transaction1.id}/balance"
                                }
                            },
                            votes: {
                                links: {
                                    self: "http://www.example.com#{request}/#{transaction1.id}/relationships/votes",
                                    related: "http://www.example.com#{request}/#{transaction1.id}/votes"
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
                            activity: {
                                links: {
                                    self: "http://www.example.com#{request}/#{transaction2.id}/relationships/activity",
                                    related: "http://www.example.com#{request}/#{transaction2.id}/activity"
                                }
                            },
                            balance: {
                                links: {
                                    self: "http://www.example.com#{request}/#{transaction2.id}/relationships/balance",
                                    related: "http://www.example.com#{request}/#{transaction2.id}/balance"
                                }
                            },
                            votes: {
                                links: {
                                    self: "http://www.example.com#{request}/#{transaction2.id}/relationships/votes",
                                    related: "http://www.example.com#{request}/#{transaction2.id}/votes"
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

      expect_transaction_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_transaction_record_count_same

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

      expect_transaction_record_count_same

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
                        activity: {
                            links: {
                                self: "http://www.example.com#{request}/relationships/activity",
                                related: "http://www.example.com#{request}/activity"
                            }
                        },
                        balance: {
                            links: {
                                self: "http://www.example.com#{request}/relationships/balance",
                                related: "http://www.example.com#{request}/balance"
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
      before do
        get request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_transaction_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_transaction_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'POST api/v1/transactions' do
    let (:request) {"/api/v1/transactions"}
    let! (:transaction) {build(:transaction)}
    let! (:activity) {create(:activity)}
    let! (:sender) {create(:user, :api_token)}
    let! (:receiver) {create(:user)}
    let! (:balance) {create(:balance, :current)}
    let! (:record_count_before_request) {Transaction.count}

    context 'with a valid api-token' do
      context 'and an image attachment' do

        # TODO add integration test for adding a transaction with an image attachment

        it 'persists the created transaction with an image attachment'
        it 'increases the record count'
        it 'returns the created transaction'
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
                           amount: transaction.amount
                       },
                       relationships: {
                           activity: {
                               data: {
                                   type: 'activities',
                                   id: activity.id
                               }
                           },
                           sender: {
                               data: {
                                   type: 'users',
                                   id: sender.id
                               }
                           },
                           receiver: {
                               data: {
                                   type: 'users',
                                   id: receiver.id
                               }
                           },
                           balance: {
                               data: {
                                   type: 'balances',
                                   id: balance.id
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

        expect_transaction_record_count_increase

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
                                  self: "http://www.example.com#{request}/#{assigned_id}/relationships/sender",
                                  related: "http://www.example.com#{request}/#{assigned_id}/sender"
                              }
                          },
                          receiver: {
                              links: {
                                  self: "http://www.example.com#{request}/#{assigned_id}/relationships/receiver",
                                  related: "http://www.example.com#{request}/#{assigned_id}/receiver"
                              }
                          },
                          activity: {
                              links: {
                                  self: "http://www.example.com#{request}/#{assigned_id}/relationships/activity",
                                  related: "http://www.example.com#{request}/#{assigned_id}/activity"
                              }
                          },
                          balance: {
                              links: {
                                  self: "http://www.example.com#{request}/#{assigned_id}/relationships/balance",
                                  related: "http://www.example.com#{request}/#{assigned_id}/balance"
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
                         amount: transaction.amount
                     },
                     relationships: {
                         activity: {
                             data: {
                                 type: 'activities',
                                 id: activity.id
                             }
                         },
                         sender: {
                             data: {
                                 type: 'users',
                                 id: sender.id
                             }
                         },
                         receiver: {
                             data: {
                                 type: 'users',
                                 id: receiver.id
                             }
                         },
                         balance: {
                             data: {
                                 type: 'balances',
                                 id: balance.id
                             }
                         }
                     }
                 }
             }.to_json
      end

      expect_transaction_record_count_same

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
                     type: 'transactions',
                     attributes: {
                         amount: transaction.amount
                     },
                     relationships: {
                         activity: {
                             data: {
                                 type: 'activities',
                                 id: activity.id
                             }
                         },
                         sender: {
                             data: {
                                 type: 'users',
                                 id: sender.id
                             }
                         },
                         receiver: {
                             data: {
                                 type: 'users',
                                 id: receiver.id
                             }
                         },
                         balance: {
                             data: {
                                 type: 'balances',
                                 id: balance.id
                             }
                         }
                     }
                 }
             }.to_json
      end

      expect_transaction_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'PATCH api/v1/transactions/:id' do
    let (:request) {"/api/v1/transactions/#{transaction.id}"}
    let! (:transaction) {create(:transaction)}
    let! (:activity) {create(:activity)}
    let! (:sender) {create(:user, :api_token)}
    let! (:receiver) {create(:user)}
    let! (:balance) {create(:balance, :current)}
    let (:edited_amount) {500}
    let! (:record_count_before_request) {Transaction.count}

    context 'with a valid api-token' do
      context 'and updated values' do
        before do
          patch request,
                headers: {
                    'Api-Token': sender.api_token,
                    'Content-Type': 'application/vnd.api+json'
                },
                params: {
                    data: {
                        id: transaction.id,
                        type: 'transactions',
                        attributes: {
                            amount: edited_amount
                        },
                        relationships: {
                            activity: {
                                data: {
                                    type: 'activities',
                                    id: activity.id
                                }
                            },
                            sender: {
                                data: {
                                    type: 'users',
                                    id: sender.id
                                }
                            },
                            receiver: {
                                data: {
                                    type: 'users',
                                    id: receiver.id
                                }
                            },
                            balance: {
                                data: {
                                    type: 'balances',
                                    id: balance.id
                                }
                            }
                        }
                    }
                }.to_json
        end

        it 'persists the updated transaction associated with the id with updated values' do
          updated_transaction = Transaction.find(transaction.id)

          expect(updated_transaction.amount).to eq(edited_amount)
        end

        expect_transaction_record_count_same

        it 'returns the updated transaction associated with the id with updated values' do
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
                          'updated-at': assigned_updated_at,
                          amount: edited_amount,
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
                          activity: {
                              links: {
                                  self: "http://www.example.com#{request}/relationships/activity",
                                  related: "http://www.example.com#{request}/activity"
                              }
                          },
                          balance: {
                              links: {
                                  self: "http://www.example.com#{request}/relationships/balance",
                                  related: "http://www.example.com#{request}/balance"
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
      end

      context 'and without updated values' do
        before do
          patch request,
                headers: {
                    'Api-Token': sender.api_token,
                    'Content-Type': 'application/vnd.api+json'
                },
                params: {
                    data: {
                        id: transaction.id,
                        type: 'transactions',
                        relationships: {
                            activity: {
                                data: {
                                    type: 'activities',
                                    id: activity.id
                                }
                            },
                            sender: {
                                data: {
                                    type: 'users',
                                    id: sender.id
                                }
                            },
                            receiver: {
                                data: {
                                    type: 'users',
                                    id: receiver.id
                                }
                            },
                            balance: {
                                data: {
                                    type: 'balances',
                                    id: balance.id
                                }
                            }
                        }
                    }
                }.to_json
        end

        it 'persists the updated transaction associated with the id without updated values' do
          updated_transaction = Transaction.find(transaction.id)

          expect(updated_transaction.amount).to eq(transaction.amount)
        end

        expect_transaction_record_count_same

        it 'returns the updated transaction associated with the id without updated values' do
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
                          'updated-at': assigned_updated_at,
                          amount: transaction.amount,
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
                          activity: {
                              links: {
                                  self: "http://www.example.com#{request}/relationships/activity",
                                  related: "http://www.example.com#{request}/activity"
                              }
                          },
                          balance: {
                              links: {
                                  self: "http://www.example.com#{request}/relationships/balance",
                                  related: "http://www.example.com#{request}/balance"
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
                      id: transaction.id,
                      type: 'transactions',
                      relationships: {
                          activity: {
                              data: {
                                  type: 'activities',
                                  id: activity.id
                              }
                          },
                          sender: {
                              data: {
                                  type: 'users',
                                  id: sender.id
                              }
                          },
                          receiver: {
                              data: {
                                  type: 'users',
                                  id: receiver.id
                              }
                          },
                          balance: {
                              data: {
                                  type: 'balances',
                                  id: balance.id
                              }
                          }
                      }
                  }
              }.to_json
      end

      expect_transaction_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        patch request,
              headers: {
                  'Content-Type': 'application/vnd.api+json'
              },
              params: {
                  data: {
                      id: transaction.id,
                      type: 'transactions',
                      relationships: {
                          activity: {
                              data: {
                                  type: 'activities',
                                  id: activity.id
                              }
                          },
                          sender: {
                              data: {
                                  type: 'users',
                                  id: sender.id
                              }
                          },
                          receiver: {
                              data: {
                                  type: 'users',
                                  id: receiver.id
                              }
                          },
                          balance: {
                              data: {
                                  type: 'balances',
                                  id: balance.id
                              }
                          }
                      }
                  }
              }.to_json
      end

      expect_transaction_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'DELETE api/v1/transactions/:id' do
    let (:request) {"/api/v1/transactions/#{transaction.id}"}
    let! (:transaction) {create(:transaction)}
    let! (:record_count_before_request) {Transaction.count}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}

      before do
        delete request, headers: {'Api-Token': user.api_token}
      end

      it 'deletes the transaction associated with the id' do
        expect {Transaction.find(transaction.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end

      expect_transaction_record_count_decrease

      expect_status_204_no_content
    end

    context 'with an invalid api-token' do
      before do
        delete request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_transaction_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        delete request
      end

      expect_transaction_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'PUT api/v1/transactions/:id/votes/:user_id' do
    let! (:transaction) {create(:transaction)}
    let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}
    let (:default_vote_flag) {true}
    let (:default_vote_scope) {nil}
    let (:default_vote_weight) {1}
    let (:invalid_transaction_id) {-1}
    let (:invalid_user_id) {-1}

    context 'with a valid api-token' do
      context 'and a valid transaction id' do
        context 'and a valid user id' do
          let (:request) {"/api/v1/transactions/#{transaction.id}/votes/#{user.id}"}
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

          expect_vote_record_count_increase

          it 'redirects to the created vote path' do
            expect(response).to redirect_to api_v1_vote_path(Vote.last)
          end

          expect_status_302_found
        end
        context 'and an invalid user id' do
          let (:request) {"/api/v1/transactions/#{transaction.id}/votes/#{invalid_user_id}"}
          let! (:record_count_before_request) {Vote.count}

          before do
            put request, headers: {'Api-Token': user.api_token}
          end

          expect_user_record_not_found_response

          expect_vote_record_count_same

          expect_status_404_not_found
        end
      end
      context 'an an invalid transaction id' do
        context 'and a valid user id' do
          let (:request) {"/api/v1/transactions/#{invalid_transaction_id}/votes/#{user.id}"}
          let! (:record_count_before_request) {Vote.count}

          before do
            put request, headers: {'Api-Token': user.api_token}
          end

          expect_transaction_record_not_found_response

          expect_vote_record_count_same

          expect_status_404_not_found
        end

        context 'and an invalid user id' do
          let (:request) {"/api/v1/transactions/#{invalid_transaction_id}/votes/#{invalid_user_id}"}
          let! (:record_count_before_request) {Vote.count}

          before do
            put request, headers: {'Api-Token': user.api_token}
          end

          expect_transaction_record_not_found_response

          expect_vote_record_count_same

          expect_status_404_not_found
        end
      end
    end

    context 'with an invalid api-token' do
      let (:request) {"/api/v1/transactions/#{transaction.id}/votes/#{user.id}"}
      let! (:record_count_before_request) {Vote.count}

      before do
        put request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_vote_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let (:request) {"/api/v1/transactions/#{transaction.id}/votes/#{user.id}"}
      let! (:record_count_before_request) {Vote.count}

      before do
        put request
      end

      expect_vote_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'DELETE api/v1/transactions/:id/votes/:user_id' do
    let! (:transaction) {create(:transaction)}
    let! (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}
    let!(:vote) {
      create(:vote, votable_type: 'Transaction', votable_id: transaction.id, voter_type: 'User', voter_id: user.id)
    }
    let (:invalid_transaction_id) {-1}
    let (:invalid_user_id) {-1}

    context 'with a valid api-token' do
      context 'and a valid transaction id' do
        context 'and a valid user id' do
          let (:request) {"/api/v1/transactions/#{transaction.id}/votes/#{user.id}"}
          let! (:record_count_before_request) {Vote.count}

          before do
            delete request, headers: {'Api-Token': user.api_token}
          end

          it "deletes the vote associated with the transaction and user id's" do
            expect {Vote.find(vote.id)}.to raise_error(ActiveRecord::RecordNotFound)
          end

          expect_vote_record_count_decrease

          expect_status_204_no_content
        end
        context 'and an invalid user id' do
          let (:request) {"/api/v1/transactions/#{transaction.id}/votes/#{invalid_user_id}"}
          let! (:record_count_before_request) {Vote.count}

          before do
            delete request, headers: {'Api-Token': user.api_token}
          end

          expect_user_record_not_found_response

          expect_vote_record_count_same

          expect_status_404_not_found
        end
      end
      context 'an an invalid transaction id' do
        context 'and a valid user id' do
          let (:request) {"/api/v1/transactions/#{invalid_transaction_id}/votes/#{user.id}"}
          let! (:record_count_before_request) {Vote.count}

          before do
            delete request, headers: {'Api-Token': user.api_token}
          end

          expect_transaction_record_not_found_response

          expect_vote_record_count_same

          expect_status_404_not_found
        end

        context 'and an invalid user id' do
          let (:request) {"/api/v1/transactions/#{invalid_transaction_id}/votes/#{invalid_user_id}"}
          let! (:record_count_before_request) {Vote.count}

          before do
            delete request, headers: {'Api-Token': user.api_token}
          end

          expect_transaction_record_not_found_response

          expect_vote_record_count_same

          expect_status_404_not_found
        end
      end
    end

    context 'with an invalid api-token' do
      let (:request) {"/api/v1/transactions/#{transaction.id}/votes/#{user.id}"}
      let! (:record_count_before_request) {Vote.count}

      before do
        delete request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_vote_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let (:request) {"/api/v1/transactions/#{transaction.id}/votes/#{user.id}"}
      let! (:record_count_before_request) {Vote.count}

      before do
        delete request
      end

      expect_vote_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end
end
