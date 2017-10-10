require 'rails_helper'
require 'shared/api/v1/shared_expectations'

def expect_record_count_same
  it 'does not change the record count' do
    expect(record_count_before_request).to be == Transaction.count
  end
end

def expect_record_count_increase
  it 'increases the record count' do
    expect(record_count_before_request).to be < Transaction.count
  end
end

def expect_record_count_decrease
  it 'decreases the record count' do
    expect(record_count_before_request).to be > Transaction.count
  end
end

RSpec.describe Api::V1::TransactionsController, type: :request do
  include RequestHelpers

  describe 'GET api/v1/transactions' do
    let (:request) {'/api/v1/transactions'}
    let! (:transaction1) {create(:transaction)}
    let! (:transaction2) {create(:transaction)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}
      let! (:record_count_before_request) {Transaction.count}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      expect_record_count_same

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
                            'image-url-original': transaction2.image.url,
                            'image-url-thumb': transaction2.image.url(:thumb),
                            'image-file-name': transaction2.image_file_name,
                            'image-content-type': transaction2.image_content_type,
                            'image-file-size': transaction2.image_file_size,
                            'image-updated-at': to_api_timestamp_format(transaction2.image_updated_at)
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
      let! (:record_count_before_request) {Transaction.count}

      before do
        get request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let! (:record_count_before_request) {Transaction.count}

      before do
        get request
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'GET api/v1/transactions/:id' do
    let (:request) {"/api/v1/transactions/#{transaction.id}"}
    let! (:transaction) {create(:transaction)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}
      let! (:record_count_before_request) {Transaction.count}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      expect_record_count_same

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
      let! (:record_count_before_request) {Transaction.count}

      before do
        get request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let! (:record_count_before_request) {Transaction.count}

      before do
        get request
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  # TODO add integration tests for POST en PATCH requests

  describe 'DELETE api/v1/transactions/:id' do
    let (:request) {"/api/v1/transactions/#{transaction.id}"}
    let! (:transaction) {create(:transaction)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}
      let! (:record_count_before_request) {Transaction.count}

      before do
        delete request, headers: {'Api-Token': user.api_token}
      end

      it 'deletes the transaction associated with the id' do
        expect {Transaction.find(transaction.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end

      expect_record_count_decrease

      expect_status_204_no_content
    end

    context 'with an invalid api-token' do
      let! (:record_count_before_request) {Transaction.count}

      before do
        delete request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let! (:record_count_before_request) {Transaction.count}

      before do
        delete request
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end
end
