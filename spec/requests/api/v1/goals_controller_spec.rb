require 'rails_helper'

RSpec.describe Api::V1::GoalsController, type: :request do
  include Requests::JsonHelpers

  describe 'GET api/v1/goals' do
    let (:request) {'/api/v1/goals'}
    let! (:goal1) {create(:goal)}
    let! (:goal2) {create(:goal)}

    context 'with valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      it 'returns all goals' do
        get request, headers: {'Api-Token': user.api_token}

        expect(json['data'][0]['id']).to eq(goal1.id.to_s)
        expect(json['data'][1]['id']).to eq(goal2.id.to_s)
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

  describe 'GET api/v1/goals/:id' do
    let (:request) {"/api/v1/goals/#{goal.id}"}
    let! (:goal) {create(:goal)}

    context 'with valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      it 'returns the goal associated with the id' do
        get request, headers: {'Api-Token': user.api_token}

        expect(json['data']['id']).to eq(goal.id.to_s)
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

  describe 'POST api/v1/goals' do
    let (:request) {'/api/v1/goals'}
    let! (:goal) {build(:goal)}

    context 'with valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      it 'returns the newly created goal' do
        post request,
             headers: {'Api-Token': user.api_token, 'Content-Type': 'application/vnd.api+json'},
             params: {data: {type: 'goals', attributes: {name: goal.name, amount: goal.amount}}}.to_json

        expect(json['data']['attributes']['name']).to eq(goal.name)
        expect(json['data']['attributes']['amount']).to eq(goal.amount)
      end

      it 'persists the newly created goal' do
        expect {
          post request,
               headers: {'Api-Token': user.api_token, 'Content-Type': 'application/vnd.api+json'},
               params: {data: {type: 'goals', attributes: {name: goal.name, amount: goal.amount}}}.to_json
        }.to change {Goal.count}
      end
    end

    context 'with invalid api-token' do
      it 'returns an unauthorized message' do
        post request,
             headers: {'Api-Token': 'invalid api-token', 'Content-Type': 'application/vnd.api+json'},
             params: {data: {type: 'goals', attributes: {name: goal.name, amount: goal.amount}}}.to_json

        expect_unauthorized
      end
    end

    context 'without api-token' do
      it 'returns an unauthorized message' do
        post request,
             headers: {'Api-Token': 'application/vnd.api+json'},
             params: {data: {type: 'goals', attributes: {name: goal.name, amount: goal.amount}}}.to_json

        expect_unauthorized
      end
    end
  end

  describe 'PATCH api/v1/goals/:id' do
    let (:request) {"/api/v1/goals/#{goal.id}"}
    let! (:goal) {create(:goal)}

    context 'with valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      it 'returns the updated goal associated with the id' do
        patch request,
              headers: {'Api-Token': user.api_token, 'Content-Type': 'application/vnd.api+json'},
              params: {data: {type: 'goals', id: goal.id, attributes: {name: 'edited name', amount: 12345}}}.to_json

        expect(json['data']['attributes']['name']).to eq('edited name')
        expect(json['data']['attributes']['amount']).to eq(12345)
      end
    end

    context 'with invalid api-token' do
      it 'returns an unauthorized message' do
        patch request,
              headers: {'Api-Token': 'invalid api-token', 'Content-Type': 'application/vnd.api+json'},
              params: {data: {type: 'goals', id: goal.id, attributes: {name: 'edited name', amount: 12345}}}.to_json

        expect_unauthorized
      end
    end

    context 'without api-token' do
      it 'returns an unauthorized message' do
        patch request,
              headers: {'Content-Type': 'application/vnd.api+json'},
              params: {data: {type: 'goals', id: goal.id, attributes: {name: 'edited name', amount: 12345}}}.to_json

        expect_unauthorized
      end
    end
  end

  describe 'DELETE api/v1/goals/:id' do
    let (:request) {"/api/v1/goals/#{goal.id}"}
    let! (:goal) {create(:goal)}

    context 'with valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      it 'deletes the goal associated with the id' do
        expect {
          delete request, headers: {'Api-Token': user.api_token}
        }.to change {Goal.count}
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

  describe 'GET api/v1/goals/next_amount' do
    let (:request) {'/api/v1/goals/next_amount'}
    let! (:balance) {create(:balance)}
    let! (:goal1) {create(:goal)}
    let! (:goal2) {create(:goal)}

    context 'with valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      it 'returns the next amount' do
        get request, headers: {'Api-Token': user.api_token}

        expect(json['data']['next_amount']).to eq(Goal.next.amount)
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

  describe 'GET api/v1/goals/next_name' do
    let (:request) {'/api/v1/goals/next_name'}
    let! (:balance) {create(:balance)}
    let! (:goal1) {create(:goal)}
    let! (:goal2) {create(:goal)}

    context 'with valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      it 'returns the next name' do
        get request, headers: {'Api-Token': user.api_token}

        expect(json['data']['next_name']).to eq(Goal.next.name)
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
