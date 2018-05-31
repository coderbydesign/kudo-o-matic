# frozen_string_literal: true

require 'rails_helper'
require 'shared/api/v1/shared_expectations'

RSpec.describe Api::V2::StatisticsController, type: :request do
  include RequestHelpers

  describe 'GET api/v2/statistics/general' do
    let(:application) { create(:application) }
    let(:team) { create :team }
    let(:user) { create(:user) }
    let(:token) do
      Doorkeeper::AccessToken.create! application_id: application.id,
                                      resource_owner_id: user.id
    end
    let(:application) { create(:application) }
    let!(:balance) { Balance.current(team) }
    let(:token) do
      Doorkeeper::AccessToken.create! application_id: application.id,
                                      resource_owner_id: user.id
    end
    let(:request) { '/api/v2/statistics/general' }

    before do
      team.add_member(user)
    end

    context 'with a valid api-token' do

      context 'and a transaction' do
        let!(:transaction) { create(:transaction, balance: balance, team_id: team.id) }

        before do
          get request, headers: {
              'Authorization': "Bearer #{token.token}",
              'Content-Type': 'application/vnd.api+json',
              'Team': team.id
          }
        end

        it 'returns the correct general statistics' do
          expected =
            {
              data: {
                transactions: {
                  week: 1,
                  month: 1,
                  total: 1
                },
                kudos: {
                  week: 100,
                  month: 100,
                  total: 100
                }
              }
            }.with_indifferent_access

          expect(json).to eq(expected)
        end

        expect_status_200_ok
      end

      context 'and a transaction that has been liked' do
        let!(:transaction) { create(:transaction, balance: balance, team_id: team.id) }

        before do
          transaction.liked_by user

          get request, headers: {
              'Authorization': "Bearer #{token.token}",
              'Content-Type': 'application/vnd.api+json',
              'Team': team.id
          }
        end

        it 'returns the correct general statistics' do
          expected =
            {
              data: {
                transactions: {
                  week: 1,
                  month: 1,
                  total: 1
                },
                kudos: {
                  week: 101,
                  month: 101,
                  total: 101
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
        get request, headers: {
            'Authorization': "Invalid token",
            'Content-Type': 'application/vnd.api+json',
            'Team': team.id
        }
      end

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'GET api/v2/statistics/user' do
    let(:application) { create(:application) }
    let(:team) { create :team }
    let(:user) { create(:user) }
    let(:token) do
      Doorkeeper::AccessToken.create! application_id: application.id,
                                      resource_owner_id: user.id
    end
    let(:request) { '/api/v2/statistics/user' }

    context 'with a valid api-token' do
      let!(:balance) { Balance.current(team) }

      context 'and a transaction sent by the user' do
        let!(:transaction) { create(:transaction, balance: balance, sender: user, team_id: team.id) }

        before do
          get request, headers: {
              'Authorization': "Bearer #{token.token}",
              'Content-Type': 'application/vnd.api+json',
              'Team': team.id
          }
        end

        it 'returns the correct user statistics' do
          expected =
            {
              data: {
                sent: 1,
                received: 0,
                total: 1
              }
            }.with_indifferent_access

          expect(json).to eq(expected)
        end

        expect_status_200_ok
      end

      context 'and a transaction received by the user' do
        let!(:transaction) { create(:transaction, balance: balance, receiver: user, team_id: team.id) }

        before do
          get request, headers: {
              'Authorization': "Bearer #{token.token}",
              'Content-Type': 'application/vnd.api+json',
              'Team': team.id
          }
        end

        it 'returns the correct user statistics' do
          expected =
            {
              data: {
                sent: 0,
                received: 1,
                total: 1
              }
            }.with_indifferent_access

          expect(json).to eq(expected)
        end

        expect_status_200_ok
      end
    end

    context 'with an invalid api-token' do
      before do
        get request, headers: {
            'Authorization': "Invalid",
            'Content-Type': 'application/vnd.api+json',
            'Team': team.id
        }
      end

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_unauthorized_response

      expect_status_401_unauthorized
    end
  end

  describe 'GET api/v2/statistics/graph' do
    let(:application) { create(:application) }
    let(:team) { create :team }
    let(:user) { create(:user) }
    let(:token) do
      Doorkeeper::AccessToken.create! application_id: application.id,
                                      resource_owner_id: user.id
    end
    let(:request) { '/api/v2/statistics/graph' }

    before do
      team.add_member(user)
    end

    context 'with a valid api-token' do
      let!(:balance) { create(:balance, :current) }

      context 'and a transaction sent in this month' do
        let!(:transaction) { create(:transaction, balance: balance, team_id: team.id) }

        before do
          get request, headers: {
              'Authorization': "Bearer #{token.token}",
              'Content-Type': 'application/vnd.api+json',
              'Team': team.id
          }
        end

        it 'returns the correct graph statistics' do
          expected =
            {
              data: {
                '0': {
                  month: month_by_months_ago(0),
                  transactions: 1,
                  kudos: 100
                },
                '1': {
                  month: month_by_months_ago(1),
                  transactions: 0,
                  kudos: 0
                },
                '2': {
                  month: month_by_months_ago(2),
                  transactions: 0,
                  kudos: 0
                },
                '3': {
                  month: month_by_months_ago(3),
                  transactions: 0,
                  kudos: 0
                },
                '4': {
                  month: month_by_months_ago(4),
                  transactions: 0,
                  kudos: 0
                }
              }
            }.with_indifferent_access

          expect(json).to eq(expected)
        end

        expect_status_200_ok
      end

      context 'and a transaction sent three months ago' do
        let!(:transaction) { create(:transaction, balance: balance, created_at: 3.months.ago, team_id: team.id) }

        before do
          get request, headers: {
              'Authorization': "Bearer #{token.token}",
              'Content-Type': 'application/vnd.api+json',
              'Team': team.id
          }
        end

        it 'returns the correct graph statistics' do
          expected =
            {
              data: {
                '0': {
                  month: month_by_months_ago(0),
                  transactions: 0,
                  kudos: 0
                },
                '1': {
                  month: month_by_months_ago(1),
                  transactions: 0,
                  kudos: 0
                },
                '2': {
                  month: month_by_months_ago(2),
                  transactions: 0,
                  kudos: 0
                },
                '3': {
                  month: month_by_months_ago(3),
                  transactions: 1,
                  kudos: 100
                },
                '4': {
                  month: month_by_months_ago(4),
                  transactions: 0,
                  kudos: 0
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
        get request, headers: {
            'Authorization': "Invalid",
            'Content-Type': 'application/vnd.api+json',
            'Team': team.id
        }
      end

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    context 'without an api-token' do
      before do
        get request
      end

      expect_unauthorized_response

      expect_status_401_unauthorized
    end

    private

    def month_by_months_ago(months_ago)
      months_ago.month.ago.beginning_of_month.strftime('%B')
    end
  end
end
