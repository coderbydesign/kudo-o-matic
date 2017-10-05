require 'rails_helper'
require 'shared/api/v1/unauthorized'

RSpec.describe Api::V1::TransactionsController, type: :request do
  include RequestHelpers

  let (:host) {'http://www.example.com'}
  let (:resource_type) {'transactions'}
  let (:relationship_type_sender) {'sender'}
  let (:relationship_type_receiver) {'receiver'}
  let (:relationship_type_balance) {'balance'}
  let (:relationship_type_activity) {'activity'}
  let (:relationship_type_votes) {'votes'}

  describe 'GET api/v1/transactions' do
    let (:request) {'/api/v1/transactions'}
    let! (:transaction1) {create(:transaction)}
    let! (:transaction2) {create(:transaction)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      it 'returns all transactions' do
        expected =
            {
                data: [
                    {
                        id: transaction1.id.to_s,
                        type: resource_type,
                        links: {
                            self: "#{host}#{request}/#{transaction1.id}"
                        },
                        attributes: {
                            'created-at': to_api_timestamp_format(transaction1.created_at),
                            'updated-at': to_api_timestamp_format(transaction1.updated_at),
                            amount: transaction1.amount,
                            'image-file-name': transaction1.image_file_name,
                            'image-content-type': transaction1.image_content_type,
                            'image-file-size': transaction1.image_file_size,
                            'image-updated-at': to_api_timestamp_format(transaction1.image_updated_at),
                        },
                        relationships: {
                            sender: {
                                links: {
                                    self: "#{host}#{request}/#{transaction1.id}/relationships/#{relationship_type_sender}",
                                    related: "#{host}#{request}/#{transaction1.id}/#{relationship_type_sender}"
                                }
                            },
                            receiver: {
                                links: {
                                    self: "#{host}#{request}/#{transaction1.id}/relationships/#{relationship_type_receiver}",
                                    related: "#{host}#{request}/#{transaction1.id}/#{relationship_type_receiver}"
                                }
                            },
                            activity: {
                                links: {
                                    self: "#{host}#{request}/#{transaction1.id}/relationships/#{relationship_type_activity}",
                                    related: "#{host}#{request}/#{transaction1.id}/#{relationship_type_activity}"
                                }
                            },
                            balance: {
                                links: {
                                    self: "#{host}#{request}/#{transaction1.id}/relationships/#{relationship_type_balance}",
                                    related: "#{host}#{request}/#{transaction1.id}/#{relationship_type_balance}"
                                }
                            },
                            votes: {
                                links: {
                                    self: "#{host}#{request}/#{transaction1.id}/relationships/#{relationship_type_votes}",
                                    related: "#{host}#{request}/#{transaction1.id}/#{relationship_type_votes}"
                                }
                            }
                        }
                    },
                    {
                        id: transaction2.id.to_s,
                        type: resource_type,
                        links: {
                            self: "#{host}#{request}/#{transaction2.id}"
                        },
                        attributes: {
                            'created-at': to_api_timestamp_format(transaction2.created_at),
                            'updated-at': to_api_timestamp_format(transaction2.updated_at),
                            amount: transaction2.amount,
                            'image-file-name': transaction2.image_file_name,
                            'image-content-type': transaction2.image_content_type,
                            'image-file-size': transaction2.image_file_size,
                            'image-updated-at': to_api_timestamp_format(transaction2.image_updated_at)
                        },
                        relationships: {
                            sender: {
                                links: {
                                    self: "#{host}#{request}/#{transaction2.id}/relationships/#{relationship_type_sender}",
                                    related: "#{host}#{request}/#{transaction2.id}/#{relationship_type_sender}"
                                }
                            },
                            receiver: {
                                links: {
                                    self: "#{host}#{request}/#{transaction2.id}/relationships/#{relationship_type_receiver}",
                                    related: "#{host}#{request}/#{transaction2.id}/#{relationship_type_receiver}"
                                }
                            },
                            activity: {
                                links: {
                                    self: "#{host}#{request}/#{transaction2.id}/relationships/#{relationship_type_activity}",
                                    related: "#{host}#{request}/#{transaction2.id}/#{relationship_type_activity}"
                                }
                            },
                            balance: {
                                links: {
                                    self: "#{host}#{request}/#{transaction2.id}/relationships/#{relationship_type_balance}",
                                    related: "#{host}#{request}/#{transaction2.id}/#{relationship_type_balance}"
                                }
                            },
                            votes: {
                                links: {
                                    self: "#{host}#{request}/#{transaction2.id}/relationships/#{relationship_type_votes}",
                                    related: "#{host}#{request}/#{transaction2.id}/#{relationship_type_votes}"
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

      expect_unauthorized_response_and_status_code
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_unauthorized_response_and_status_code
    end
  end

  describe 'GET api/v1/transactions/:id' do
    let (:request) {"/api/v1/transactions/#{transaction.id}"}
    let! (:transaction) {create(:transaction)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      it 'returns the transaction associated with the id' do
        expected =
            {
                data: {
                    id: transaction.id.to_s,
                    type: resource_type,
                    links: {
                        self: "#{host}#{request}"
                    },
                    attributes: {
                        'created-at': to_api_timestamp_format(transaction.created_at),
                        'updated-at': to_api_timestamp_format(transaction.updated_at),
                        amount: transaction.amount,
                        'image-file-name': transaction.image_file_name,
                        'image-content-type': transaction.image_content_type,
                        'image-file-size': transaction.image_file_size,
                        'image-updated-at': to_api_timestamp_format(transaction.image_updated_at)
                    },
                    relationships: {
                        sender: {
                            links: {
                                self: "#{host}#{request}/relationships/#{relationship_type_sender}",
                                related: "#{host}#{request}/#{relationship_type_sender}"
                            }
                        },
                        receiver: {
                            links: {
                                self: "#{host}#{request}/relationships/#{relationship_type_receiver}",
                                related: "#{host}#{request}/#{relationship_type_receiver}"
                            }
                        },
                        activity: {
                            links: {
                                self: "#{host}#{request}/relationships/#{relationship_type_activity}",
                                related: "#{host}#{request}/#{relationship_type_activity}"
                            }
                        },
                        balance: {
                            links: {
                                self: "#{host}#{request}/relationships/#{relationship_type_balance}",
                                related: "#{host}#{request}/#{relationship_type_balance}"
                            }
                        },
                        votes: {
                            links: {
                                self: "#{host}#{request}/relationships/#{relationship_type_votes}",
                                related: "#{host}#{request}/#{relationship_type_votes}"
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

      expect_unauthorized_response_and_status_code
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_unauthorized_response_and_status_code
    end
  end

  # TODO add integration tests for POST en PATCH requests

  describe 'DELETE api/v1/transactions/:id' do
    let (:request) {"/api/v1/transactions/#{transaction.id}"}
    let! (:transaction) {create(:transaction)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      before do
        delete request, headers: {'Api-Token': user.api_token}
      end

      it 'deletes the transaction associated with the id' do
        expect {Transaction.find(transaction.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'returns a 204 (no content) status code' do
        expect(response).to have_http_status(204)
      end
    end

    context 'with an invalid api-token' do
      before do
        delete request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_unauthorized_response_and_status_code
    end

    context 'without an api-token' do
      before do
        delete request
      end

      expect_unauthorized_response_and_status_code
    end
  end
end
