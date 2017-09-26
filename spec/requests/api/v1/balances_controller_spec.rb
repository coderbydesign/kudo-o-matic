require 'rails_helper'

RSpec.describe Api::V1::BalancesController, type: :request do
  include Requests::JsonHelpers

  describe 'GET api/v1/balances' do
    let (:request) {'/api/v1/balances'}
    let! (:balance1) {create(:balance)}
    let! (:balance2) {create(:balance)}

    context 'with valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      it 'returns all balances' do
        get request, headers: {'Api-Token': user.api_token}

        expect(json['data'][0]['id']).to eq(balance1.id.to_s)
        expect(json['data'][1]['id']).to eq(balance2.id.to_s)
      end
    end

    context 'with invalid api-token' do
      it 'returns an unauthorized message' do
        get request, headers: {'Api-Token': 'invalid api-token'}

        expect_unauthorized
      end
    end

    context 'without api-token' do
      it 'returns an unauthorized message' do
        get request

        expect_unauthorized
      end
    end
  end

  describe 'GET api/v1/balances/:id' do
    let (:request) {"/api/v1/balances/#{balance.id}"}
    let! (:balance) {create(:balance)}

    context 'with valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      it 'returns the balance associated with the id' do
        get request, headers: {'Api-Token': user.api_token}

        expect(json['data']['id']).to eq(balance.id.to_s)
      end
    end

    context 'with invalid api-token' do
      it 'returns an unauthorized message' do
        get request, headers: {'Api-Token': 'invalid api-token'}

        expect_unauthorized
      end
    end

    context 'without api-token' do
      it 'returns an unauthorized message' do
        get request

        expect_unauthorized
      end
    end
  end

  describe 'POST api/v1/balances' do
    let (:request) {'/api/v1/balances'}
    let! (:balance) {build(:balance)}

    context 'with valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      it 'returns the newly created balance' do
        post request,
             headers: {'Api-Token': user.api_token, 'Content-Type': 'application/vnd.api+json'},
             params: {data: {type: 'balances', attributes: {name: balance.name, current: balance.current}}}.to_json

        expect(json['data']['attributes']['name']).to eq(balance.name)
        expect(json['data']['attributes']['current']).to eq(balance.current)
      end

      it 'persists the newly created balance' do
        expect {
          post request,
               headers: {'Api-Token': user.api_token, 'Content-Type': 'application/vnd.api+json'},
               params: {data: {type: 'balances', attributes: {name: balance.name, current: balance.current}}}.to_json
        }.to change {Balance.count}
      end
    end

    context 'with invalid api-token' do
      it 'returns an unauthorized message' do
        post request,
             headers: {'Api-Token': 'invalid api-token', 'Content-Type': 'application/vnd.api+json'},
             params: {data: {type: 'balance', attributes: {name: balance.name, current: balance.current}}}.to_json

        expect_unauthorized
      end
    end

    context 'without api-token' do
      it 'returns an unauthorized message' do
        post request,
             headers: {'Api-Token': 'application/vnd.api+json'},
             params: {data: {type: 'balance', attributes: {name: balance.name, current: balance.current}}}.to_json

        expect_unauthorized
      end
    end
  end

  describe 'PATCH api/v1/balances/:id' do
    let (:request) {"/api/v1/balances/#{balance.id}"}
    let! (:balance) {create(:balance)}

    context 'with valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      it 'returns the updated balance associated with the id' do
        patch request,
              headers: {'Api-Token': user.api_token, 'Content-Type': 'application/vnd.api+json'},
              params: {data: {type: 'balances', id: balance.id, attributes: {name: 'edited name', current: true}}}.to_json

        expect(json['data']['attributes']['name']).to eq('edited name')
        expect(json['data']['attributes']['current']).to eq(true)
      end
    end

    context 'with invalid api-token' do
      it 'returns an unauthorized message' do
        patch request,
              headers: {'Api-Token': 'invalid api-token', 'Content-Type': 'application/vnd.api+json'},
              params: {data: {type: 'balances', id: balance.id, attributes: {name: 'edited name', current: true}}}.to_json

        expect_unauthorized
      end
    end

    context 'without api-token' do
      it 'returns an unauthorized message' do
        patch request,
              headers: {'Content-Type': 'application/vnd.api+json'},
              params: {data: {type: 'balances', id: balance.id, attributes: {name: 'edited name', current: true}}}.to_json

        expect_unauthorized
      end
    end
  end

  describe 'DELETE api/v1/balances/:id' do
    let (:request) {"/api/v1/balances/#{balance.id}"}
    let! (:balance) {create(:balance)}

    context 'with valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      it 'deletes the balance associated with the id' do
        expect {
          delete request, headers: {'Api-Token': user.api_token}
        }.to change {Balance.count}
      end
    end

    context 'with invalid api-token' do
      it 'returns an unauthorized message' do
        delete request, headers: {'Api-Token': 'invalid api-token'}

        expect_unauthorized
      end
    end

    context 'without api-token' do
      it 'returns an unauthorized message' do
        delete request

        expect_unauthorized
      end
    end
  end

  describe 'GET /api/v1/balances/current_amount' do
    let (:request) {'/api/v1/balances/current_amount'}
    let! (:balance) {create(:balance, :current)}

    context 'with valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      it 'returns the current amount' do
        get request, headers: {'Api-Token': user.api_token}

        expect(json['data']['current_amount']).to eq(Balance.current.amount)
      end
    end

    context 'with invalid api-token' do
      it 'returns an unauthorized message' do
        get request, headers: {'Api-Token': 'invalid api-token'}

        expect_unauthorized
      end
    end

    context 'without api-token' do
      it 'returns an unauthorized message' do
        get request

        expect_unauthorized
      end
    end
  end
end
