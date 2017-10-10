require 'rails_helper'
require 'shared/api/v1/shared_expectations'

def expect_record_count_same
  it 'does not change the record count' do
    expect(record_count_before_request).to be == Balance.count
  end
end

def expect_record_count_increase
  it 'increases the record count' do
    expect(record_count_before_request).to be < Balance.count
  end
end

def expect_record_count_decrease
  it 'decreases the record count' do
    expect(record_count_before_request).to be > Balance.count
  end
end

RSpec.describe Api::V1::BalancesController, type: :request do
  include RequestHelpers

  describe 'GET api/v1/balances' do
    let (:request) {'/api/v1/balances'}
    let! (:balance1) {create(:balance)}
    let! (:balance2) {create(:balance)}
    let! (:record_count_before_request) {Balance.count}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      expect_record_count_same

      it 'returns all balances' do
        expected =
            {
                data: [
                    {
                        id: balance1.id.to_s,
                        type: 'balances',
                        links: {
                            self: "http://www.example.com#{request}/#{balance1.id}"
                        },
                        attributes: {
                            'created-at': to_api_timestamp_format(balance1.created_at),
                            'updated-at': to_api_timestamp_format(balance1.updated_at),
                            name: balance1.name,
                            current: balance1.current
                        },
                        relationships: {
                            transactions: {
                                links: {
                                    self: "http://www.example.com#{request}/#{balance1.id}/relationships/transactions",
                                    related: "http://www.example.com#{request}/#{balance1.id}/transactions"
                                }
                            }
                        }
                    },
                    {
                        id: balance2.id.to_s,
                        type: 'balances',
                        links: {
                            self: "http://www.example.com#{request}/#{balance2.id}"
                        },
                        attributes: {
                            'created-at': to_api_timestamp_format(balance2.created_at),
                            'updated-at': to_api_timestamp_format(balance2.updated_at),
                            name: balance2.name,
                            current: balance1.current
                        },
                        relationships: {
                            transactions: {
                                links: {
                                    self: "http://www.example.com#{request}/#{balance2.id}/relationships/transactions",
                                    related: "http://www.example.com#{request}/#{balance2.id}/transactions"
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

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'GET api/v1/balances/:id' do
    let (:request) {"/api/v1/balances/#{balance.id}"}
    let! (:balance) {create(:balance)}
    let! (:record_count_before_request) {Balance.count}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      expect_record_count_same

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
                        current: balance.current
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
        get request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'POST api/v1/balances' do
    let (:request) {'/api/v1/balances'}
    let! (:balance) {build(:balance)}
    let! (:record_count_before_request) {Balance.count}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}

      before do
        post request,
             headers: {'Api-Token': user.api_token, 'Content-Type': 'application/vnd.api+json'},
             params: {data: {type: 'balances', attributes: {name: balance.name, current: balance.current}}}.to_json
      end

      it 'persists the created balance with the correct values' do
        new_balance = Balance.find(assigned_id)

        expect(new_balance.name).to eq(balance.name)
        expect(new_balance.current).to eq(balance.current)
      end

      expect_record_count_increase

      it 'returns the created balance' do
        expected =
            {
                data: {
                    id: assigned_id,
                    type: 'balances',
                    links: {
                        self: "http://www.example.com#{request}/#{assigned_id}"
                    },
                    attributes: {
                        'created-at': assigned_created_at,
                        'updated-at': assigned_updated_at,
                        name: balance.name,
                        current: balance.current
                    },
                    relationships: {
                        transactions: {
                            links: {
                                self: "http://www.example.com#{request}/#{assigned_id}/relationships/transactions",
                                related: "http://www.example.com#{request}/#{assigned_id}/transactions"
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
      before do
        post request,
             headers: {'Api-Token': 'invalid api-token', 'Content-Type': 'application/vnd.api+json'},
             params: {data: {type: 'balances', attributes: {name: balance.name, current: balance.current}}}.to_json
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        post request,
             headers: {'Api-Token': 'application/vnd.api+json'},
             params: {data: {type: 'balances', attributes: {name: balance.name, current: balance.current}}}.to_json
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'PATCH api/v1/balances/:id' do
    let (:request) {"/api/v1/balances/#{balance.id}"}
    let! (:balance) {create(:balance)}
    let (:edited_name) {'edited name'}
    let (:edited_current) {true}
    let! (:record_count_before_request) {Balance.count}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}

      context 'and updated values' do
        before do
          patch request,
                headers: {
                    'Api-Token': user.api_token,
                    'Content-Type': 'application/vnd.api+json'
                },
                params: {
                    data: {
                        type: 'balances',
                        id: balance.id,
                        attributes: {
                            name: edited_name,
                            current: edited_current
                        }
                    }
                }.to_json
        end

        it 'persists the updated balance associated with the id with updated values' do
          updated_balance = Balance.find(balance.id)

          expect(updated_balance.name).to eq(edited_name)
          expect(updated_balance.current).to eq(edited_current)
        end

        expect_record_count_same

        it 'returns the updated balance associated with the id with updated values' do
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
                          'updated-at': assigned_updated_at,
                          name: edited_name,
                          current: edited_current
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

      context 'and without updated values' do
        before do
          patch request,
                headers: {'Api-Token': user.api_token, 'Content-Type': 'application/vnd.api+json'},
                params: {data: {type: 'balances', id: balance.id}}.to_json
        end

        it 'persists the updated balance associated with the id without updated values' do
          updated_balance = Balance.find(balance.id)

          expect(updated_balance.name).to eq(balance.name)
          expect(updated_balance.current).to eq(balance.current)
        end

        expect_record_count_same

        it 'returns the updated balance associated with the id without updated values' do
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
                          current: balance.current
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
                      type: 'balances',
                      id: balance.id,
                      attributes: {
                          name: edited_name,
                          current: edited_current
                      }
                  }
              }.to_json
      end

      expect_record_count_same

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
                      type: 'balances',
                      id: balance.id,
                      attributes: {
                          name: edited_name,
                          current: edited_current
                      }
                  }
              }.to_json
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'DELETE api/v1/balances/:id' do
    let (:request) {"/api/v1/balances/#{balance.id}"}
    let! (:balance) {create(:balance)}
    let! (:record_count_before_request) {Balance.count}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}

      before do
        delete request, headers: {'Api-Token': user.api_token}
      end

      it 'deletes the balance associated with the id' do
        expect {Balance.find(balance.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end

      expect_record_count_decrease

      expect_status_204_no_content
    end

    context 'with an invalid api-token' do
      before do
        delete request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        delete request
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'GET /api/v1/balances/current' do
    let (:request) {'/api/v1/balances/current'}
    let! (:balance) {create(:balance, :current)}
    let! (:record_count_before_request) {Balance.count}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      expect_record_count_same

      it 'returns the current balance' do
        expected =
            {
                data: {
                    id: balance.id.to_s,
                    type: 'balances',
                    attributes: {
                        'created-at': to_api_timestamp_format(balance.created_at),
                        'updated-at': to_api_timestamp_format(balance.updated_at),
                        name: balance.name,
                        current: balance.current,
                        amount: balance.amount
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

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_record_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end
end
