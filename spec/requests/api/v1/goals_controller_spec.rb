require 'rails_helper'

RSpec.describe Api::V1::GoalsController, type: :request do
  include Requests::JsonHelpers

  describe 'GET api/v1/goals' do
    let! (:goal1) {create(:goal)}
    let! (:goal2) {create(:goal)}

    context 'with valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      it 'returns all goals' do
        get '/api/v1/goals', headers: {'Api-Token': user.api_token}

        expect(json['data'][0]['id']).to eq(goal1.id.to_s)
        expect(json['data'][1]['id']).to eq(goal2.id.to_s)
      end
    end

    context 'with invalid api-token' do
      it 'returns an unauthorized message' do
        get '/api/v1/goals', headers: {'Api-Token': 'invalid api-token'}

        expect(json).to match({error: 'Unauthorized'})
      end
    end

    context 'without api-token' do
      it 'returns an unauthorized message' do
        get '/api/v1/goals'

        expect(json).to match({error: 'Unauthorized'})
      end
    end
  end

  describe 'GET api/v1/goals/:id' do
    let! (:goal) {create(:goal)}

    context 'with valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      it 'returns the goal associated with the id' do
        get "/api/v1/goals/#{goal.id}", headers: {'Api-Token': user.api_token}

        expect(json['data']['id']).to eq(goal.id.to_s)
      end
    end

    context 'with invalid api-token' do
      it 'returns an unauthorized message' do
        get "/api/v1/goals/#{goal.id}", headers: {'Api-Token': 'invalid api-token'}

        expect(json).to match({error: 'Unauthorized'})
      end
    end

    context 'without api-token' do
      it 'returns an unauthorized message' do
        get "/api/v1/goals/#{goal.id}"

        expect(json).to match({error: 'Unauthorized'})
      end
    end
  end

  describe 'POST api/v1/goals' do
    let! (:goal) {build(:goal)}

    context 'with valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      it 'returns the newly created goal' do
        post '/api/v1/goals',
             headers: {'Api-Token': user.api_token, 'Content-Type': 'application/vnd.api+json'},
             params: {data: {type: 'goals', attributes: {name: goal.name, amount: goal.amount}}}.to_json

        expect(json['data']['attributes']['name']).to eq(goal.name)
        expect(json['data']['attributes']['amount']).to eq(goal.amount)
      end

      it 'persists the newly created goal' do
        expect {
          post '/api/v1/goals',
               headers: {'Api-Token': user.api_token, 'Content-Type': 'application/vnd.api+json'},
               params: {data: {type: 'goals', attributes: {name: goal.name, amount: goal.amount}}}.to_json
        }.to change {Goal.count}
      end
    end

    context 'with invalid api-token' do
      it 'returns an unauthorized message' do
        post '/api/v1/goals',
             headers: {'Api-Token': 'invalid api-token', 'Content-Type': 'application/vnd.api+json'},
             params: {data: {type: 'goals', attributes: {name: goal.name, amount: goal.amount}}}.to_json

        expect(json).to match({error: 'Unauthorized'})
      end
    end

    context 'without api-token' do
      it 'returns an unauthorized message' do
        post '/api/v1/goals',
             headers: {'Api-Token': 'application/vnd.api+json'},
             params: {data: {type: 'goals', attributes: {name: goal.name, amount: goal.amount}}}.to_json

        expect(json).to match({error: 'Unauthorized'})
      end
    end
  end

  describe 'PATCH api/v1/goals/:id' do
    let! (:goal) {create(:goal)}

    context 'with valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      it 'returns the updated goal associated with the id' do
        patch "/api/v1/goals/#{goal.id}",
              headers: {'Api-Token': user.api_token, 'Content-Type': 'application/vnd.api+json'},
              params: {data: {type: 'goals', id: goal.id, attributes: {name: 'edited name', amount: 12345}}}.to_json

        expect(json['data']['attributes']['name']).to eq('edited name')
        expect(json['data']['attributes']['amount']).to eq(12345)
      end
    end

    context 'with invalid api-token' do
      it 'returns an unauthorized message' do
        patch "/api/v1/goals/#{goal.id}",
              headers: {'Api-Token': 'invalid api-token', 'Content-Type': 'application/vnd.api+json'},
              params: {data: {type: 'goals', id: goal.id, attributes: {name: 'edited name', amount: 12345}}}.to_json

        expect(json).to match({error: 'Unauthorized'})
      end
    end

    context 'without api-token' do
      it 'returns an unauthorized message' do
        patch "/api/v1/goals/#{goal.id}",
              headers: {'Content-Type': 'application/vnd.api+json'},
              params: {data: {type: 'goals', id: goal.id, attributes: {name: 'edited name', amount: 12345}}}.to_json

        expect(json).to match({error: 'Unauthorized'})
      end
    end
  end

  describe 'DELETE api/v1/goals/:id' do
    let! (:goal) {create(:goal)}

    context 'with valid api-token' do
      let (:user) {create(:user, api_token: 'X0EfAbSlaeQkXm6gFmNtKA')}

      it 'deletes the goal associated with the id' do
        expect {
          delete "/api/v1/goals/#{goal.id}", headers: {'Api-Token': user.api_token}
        }.to change {Goal.count}
      end
    end

    context 'with invalid api-token' do
      it 'returns an unauthorized message' do
        delete "/api/v1/goals/#{goal.id}", headers: {'Api-Token': 'invalid api-token'}

        expect(json).to match({error: 'Unauthorized'})
      end
    end

    context 'without api-token' do
      it 'returns an unauthorized message' do
        delete "/api/v1/goals/#{goal.id}"

        expect(json).to match({error: 'Unauthorized'})
      end
    end
  end
end
