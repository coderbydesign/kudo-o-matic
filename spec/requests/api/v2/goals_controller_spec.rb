# frozen_string_literal: true

require 'rails_helper'
require 'shared/api/v1/shared_expectations'

RSpec.describe Api::V2::GoalsController, type: :request do
  include RequestHelpers

  # Skip the after_create callback in this spec, because we are working with specific balances and goals
  before do
    Team.skip_callback(:create, :after, :setup_team)
  end

  # After this spec, set the callback again, so other specs can make use of it
  after do
    Team.set_callback(:create, :after, :setup_team)
  end

  describe 'GET api/v2/goals/:id' do
    let(:application) { create(:application) }
    let(:team) { create(:team) }
    let(:user) { create(:user) }
    let(:token) do
      Doorkeeper::AccessToken.create! application_id: application.id,
                                      resource_owner_id: user.id
    end
    let(:request) { "/api/v2/goals/#{goal.id}" }
    let!(:goal) { create(:goal) }
    let!(:record_count_before_request) { Goal.count }


    before do
      team.add_member(user)
    end

    context 'with a valid api-token' do
      before do
        get request, headers: {
            'Authorization': "Bearer #{token.token}",
            'Content-Type': 'application/vnd.api+json',
            'Team': team.id
        }
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
        get request, format: :json, access_token: 'Invalid token'
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

  describe 'GET api/v2/goals/next' do
    let(:application) { create(:application) }
    let(:team) {create :team }
    let(:user) { create(:user) }
    let(:token) do
      Doorkeeper::AccessToken.create! application_id: application.id,
                                      resource_owner_id: user.id
    end
    let(:request) { '/api/v2/goals/next' }

    context 'with a valid api-token' do
      context 'and a next goal that is not achieved' do
        let!(:goal) { create(:goal) }
        let!(:record_count_before_request) { Goal.count }

        before do
          get request, headers: {
              'Authorization': "Bearer #{token.token}",
              'Content-Type': 'application/vnd.api+json',
              'Team': team.id
          }
        end

        expect_goal_count_same

        expect_status_200_ok
      end

      context 'and a next goal that is achieved' do
        let!(:goal) { create(:goal, :achieved) }
        let!(:record_count_before_request) { Goal.count }

        before do
          get request, headers: {
              'Authorization': "Bearer #{token.token}",
              'Content-Type': 'application/vnd.api+json',
              'Team': team.id
          }
        end

        expect_goal_count_increase

        expect_status_200_ok
      end

      context 'and no next goal' do
        let!(:record_count_before_request) { Goal.count }

        before do
          get request, headers: {
              'Authorization': "Bearer #{token.token}",
              'Content-Type': 'application/vnd.api+json',
              'Team': team.id
          }
        end

        expect_goal_count_increase

        expect_status_200_ok
      end
    end

    context 'with an invalid api-token' do
      let!(:record_count_before_request) { Goal.count }

      before do
        get request, headers: {
            'Authorization': "Invalid token",
            'Content-Type': 'application/vnd.api+json',
            'Team': team.id
        }
      end

      expect_goal_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let!(:record_count_before_request) { Goal.count }

      before do
        get request
      end

      expect_goal_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'GET api/v2/goals/previous' do
    let(:application) { create(:application) }
    let(:team) { create :team }
    let(:user) { create(:user) }
    let(:token) do
      Doorkeeper::AccessToken.create! application_id: application.id,
                                      resource_owner_id: user.id
    end
    let(:request) { '/api/v2/goals/previous' }

    context 'with a valid api-token' do
      context 'and a previous goal' do
        let!(:goal) { create(:goal, :achieved) }
        let!(:record_count_before_request) { Goal.count }

        before do
          get request, headers: {
              'Authorization': "Bearer #{token.token}",
              'Content-Type': 'application/vnd.api+json',
              'Team': team.id
          }
        end

        expect_goal_count_same

        expect_status_200_ok
      end

      context 'and no previous goal' do
        let!(:record_count_before_request) { Goal.count }

        before do
          get request, headers: {
              'Authorization': "Bearer #{token.token}",
              'Content-Type': 'application/vnd.api+json',
              'Team': team.id
          }
        end

        expect_goal_count_same

        expect_previous_goal_record_not_found_response

        expect_status_404_not_found
      end
    end

    context 'with an invalid api-token' do
      let!(:record_count_before_request) { Goal.count }

      before do
        get request, headers: {
            'Authorization': "Invalid",
            'Content-Type': 'application/vnd.api+json',
            'Team': team.id
        }
      end

      expect_goal_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      let!(:record_count_before_request) { Goal.count }

      before do
        get request
      end

      expect_goal_count_same

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end
end
