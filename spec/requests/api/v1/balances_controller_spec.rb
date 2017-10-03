require 'rails_helper'
require 'shared/api/v1/unauthorized'

RSpec.describe Api::V1::BalancesController, type: :request do
  include RequestHelpers

  let (:host) {'http://www.example.com'}
  let (:resource_type) {'balances'}
  let (:relationship_type_transactions) {'transactions'}

  describe 'GET api/v1/balances' do
    let (:request) {'/api/v1/balances'}
    let! (:balance1) {create(:balance)}
    let! (:balance2) {create(:balance)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      it 'returns all balances' do
        expected =
            {
                data: [
                    {
                        id: balance1.id.to_s,
                        type: resource_type,
                        links: {
                            self: "#{host}#{request}/#{balance1.id}"
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
                                    self: "#{host}#{request}/#{balance1.id}/relationships/#{relationship_type_transactions}",
                                    related: "#{host}#{request}/#{balance1.id}/#{relationship_type_transactions}"
                                }
                            }
                        }
                    },
                    {
                        id: balance2.id.to_s,
                        type: resource_type,
                        links: {
                            self: "#{host}#{request}/#{balance2.id}"
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
                                    self: "#{host}#{request}/#{balance2.id}/relationships/#{relationship_type_transactions}",
                                    related: "#{host}#{request}/#{balance2.id}/#{relationship_type_transactions}"
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

  describe 'GET api/v1/balances/:id' do
    let (:request) {"/api/v1/balances/#{balance.id}"}
    let! (:balance) {create(:balance)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      it 'returns the balance associated with the id' do
        expected =
            {
                data: {
                    id: balance.id.to_s,
                    type: resource_type,
                    links: {
                        self: "#{host}#{request}"
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
                                self: "#{host}#{request}/relationships/#{relationship_type_transactions}",
                                related: "#{host}#{request}/#{relationship_type_transactions}"
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

  describe 'POST api/v1/balances' do
    let (:request) {'/api/v1/balances'}
    let! (:balance) {build(:balance)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      before do
        post request,
             headers: {'Api-Token': user.api_token, 'Content-Type': 'application/vnd.api+json'},
             params: {data: {type: resource_type, attributes: {name: balance.name, current: balance.current}}}.to_json
      end

      it 'returns the newly created balance' do
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
                        name: balance.name,
                        current: balance.current
                    },
                    relationships: {
                        transactions: {
                            links: {
                                self: "#{host}#{request}/#{assigned_id}/relationships/#{relationship_type_transactions}",
                                related: "#{host}#{request}/#{assigned_id}/#{relationship_type_transactions}"
                            }
                        }
                    }
                }
            }.with_indifferent_access

        expect(json).to eq(expected)
      end

      it 'persists the newly created balance' do
        new_balance = Balance.find(assigned_id)

        expect(new_balance.name).to eq(balance.name)
        expect(new_balance.current).to eq(balance.current)
      end

      it 'returns a 201 (created) status code' do
        expect(response).to have_http_status(201)
      end
    end

    context 'with an invalid api-token' do
      before do
        post request,
             headers: {'Api-Token': 'invalid api-token', 'Content-Type': 'application/vnd.api+json'},
             params: {data: {type: resource_type, attributes: {name: balance.name, current: balance.current}}}.to_json
      end

      expect_unauthorized_message_and_status_code
    end

    context 'without an api-token' do
      before do
        post request,
             headers: {'Api-Token': 'application/vnd.api+json'},
             params: {data: {type: resource_type, attributes: {name: balance.name, current: balance.current}}}.to_json
      end

      expect_unauthorized_message_and_status_code
    end
  end

  describe 'PATCH api/v1/balances/:id' do
    let (:request) {"/api/v1/balances/#{balance.id}"}
    let! (:balance) {create(:balance)}
    let(:edited_name) {'edited name'}
    let(:edited_current) {true}

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
                        type: 'balances',
                        id: balance.id,
                        attributes: {
                            name: edited_name,
                            current: edited_current
                        }
                    }
                }.to_json
        end

        it 'returns the updated balance associated with the id with updated values' do
          expected =
              {
                  data: {
                      id: balance.id.to_s,
                      type: resource_type,
                      links: {
                          self: "#{host}#{request}"
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
                                  self: "#{host}#{request}/relationships/#{relationship_type_transactions}",
                                  related: "#{host}#{request}/#{relationship_type_transactions}"
                              }
                          }
                      }
                  }
              }.with_indifferent_access

          expect(json).to eq(expected)
        end

        it 'persists the updated balance with updated values' do
          updated_balance = Balance.find(balance.id)

          expect(updated_balance.name).to eq(edited_name)
          expect(updated_balance.current).to eq(edited_current)
        end

        it 'returns a 200 (ok) status code' do
          expect(response).to have_http_status(200)
        end
      end

      context 'and without updated values' do
        before do
          patch request,
                headers: {'Api-Token': user.api_token, 'Content-Type': 'application/vnd.api+json'},
                params: {data: {type: 'balances', id: balance.id}}.to_json
        end

        it 'returns the updated balance associated with the id without updated values' do
          expected =
              {
                  data: {
                      id: balance.id.to_s,
                      type: resource_type,
                      links: {
                          self: "#{host}#{request}"
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
                                  self: "#{host}#{request}/relationships/#{relationship_type_transactions}",
                                  related: "#{host}#{request}/#{relationship_type_transactions}"
                              }
                          }
                      }
                  }
              }.with_indifferent_access

          expect(json).to eq(expected)
        end

        it 'persists the updated balance without updated values' do
          updated_balance = Balance.find(balance.id)

          expect(updated_balance.name).to eq(balance.name)
          expect(updated_balance.current).to eq(balance.current)
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
                      type: 'balances',
                      id: balance.id,
                      attributes: {
                          name: edited_name,
                          current: edited_current
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
                      type: 'balances',
                      id: balance.id,
                      attributes: {
                          name: edited_name,
                          current: edited_current
                      }
                  }
              }.to_json
      end

      expect_unauthorized_message_and_status_code
    end
  end

  describe 'DELETE api/v1/balances/:id' do
    let (:request) {"/api/v1/balances/#{balance.id}"}
    let! (:balance) {create(:balance)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      before do
        delete request, headers: {'Api-Token': user.api_token}
      end

      it 'deletes the balance associated with the id' do
        expect {Balance.find(balance.id)}.to raise_error(ActiveRecord::RecordNotFound)
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

  describe 'GET /api/v1/balances/current' do
    let (:request) {'/api/v1/balances/current'}
    let! (:balance) {create(:balance, :current)}

    context 'with a valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      it 'returns the current balance' do
        expected =
            {
                data: {
                    id: balance.id,
                    type: resource_type,
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
end
