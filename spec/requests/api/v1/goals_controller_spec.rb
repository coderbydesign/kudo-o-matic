require 'rails_helper'
require 'shared/api/v1/shared_expectations'

RSpec.describe Api::V1::GoalsController, type: :request do
  include RequestHelpers

  describe 'GET api/v1/goals/:id' do
    let (:request) {"/api/v1/goals/#{goal.id}"}
    let! (:goal) {create(:goal)}
    let! (:record_count_before_request) {Goal.count}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}

      before do
        get request, headers: {'Api-Token': user.api_token}
      end

      expect_goal_count_same

      it 'returns the goal associated with the id' do
        expected =
            {
                data: {
                    id: goal.id.to_s,
                    type: 'goals',
                    links: {
                        self: "http://www.example.com#{request}"
                    },
                    attributes: {
                        'created-at': to_api_timestamp_format(goal.created_at),
                        'updated-at': to_api_timestamp_format(goal.updated_at),
                        name: goal.name,
                        amount: goal.amount,
                        'achieved-on': goal.achieved_on
                    },
                    relationships: {
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

      expect_goal_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_goal_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'GET api/v1/goals/next' do
    let (:request) {'/api/v1/goals/next'}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}

      context 'and a next goal that is not achieved' do
        let! (:goal) {create(:goal)}
        let! (:record_count_before_request) {Goal.count}

        before do
          get request, headers: {'Api-Token': user.api_token}
        end

        expect_goal_count_same

        it 'redirects to the next goal path' do
          expect(response).to redirect_to api_v1_goal_path(goal)
        end

        expect_status_302_found
      end

      context 'and a next goal that is achieved' do
        let! (:goal) {create(:goal, :achieved)}
        let! (:record_count_before_request) {Goal.count}

        before do
          get request, headers: {'Api-Token': user.api_token}
        end

        expect_goal_count_increase

        it 'redirects to the next goal path' do
          expect(response).to redirect_to api_v1_goal_path(Goal.last)
        end

        expect_status_302_found
      end

      context 'and no next goal' do
        let! (:record_count_before_request) {Goal.count}

        before do
          get request, headers: {'Api-Token': user.api_token}
        end

        expect_goal_count_increase

        it 'redirects to the next goal path' do
          expect(response).to redirect_to api_v1_goal_path(Goal.last)
        end

        expect_status_302_found
      end
    end

    context 'with an invalid api-token' do
      let! (:record_count_before_request) {Goal.count}

      before do
        get request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_goal_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let! (:record_count_before_request) {Goal.count}

      before do
        get request
      end

      expect_goal_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'GET api/v1/goals/previous' do
    let (:request) {'/api/v1/goals/previous'}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}

      context 'and a previous goal' do
        let! (:goal) {create(:goal, :achieved)}
        let! (:record_count_before_request) {Goal.count}

        before do
          get request, headers: {'Api-Token': user.api_token}
        end

        expect_goal_count_same

        it 'redirects to the previous goal path' do
          expect(response).to redirect_to api_v1_goal_path(goal)
        end

        expect_status_302_found
      end

      context 'and no previous goal' do
        let! (:record_count_before_request) {Goal.count}

        before do
          get request, headers: {'Api-Token': user.api_token}
        end

        expect_goal_count_same

        expect_previous_goal_record_not_found_response

        expect_status_404_not_found
      end
    end

    context 'with an invalid api-token' do
      let! (:record_count_before_request) {Goal.count}

      before do
        get request, headers: {'Api-Token': 'invalid api-token'}
      end

      expect_goal_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let! (:record_count_before_request) {Goal.count}

      before do
        get request
      end

      expect_goal_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end
end
