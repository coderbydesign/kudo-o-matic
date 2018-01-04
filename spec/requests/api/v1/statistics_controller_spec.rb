require 'rails_helper'
require 'shared/api/v1/shared_expectations'

RSpec.describe Api::V1::StatisticsController, type: :request do
  include RequestHelpers

  describe 'GET api/v1/statistics/general' do
    let (:request) {'/api/v1/statistics/general'}

    context 'with a valid api-token' do
      let! (:user) {create(:user, :api_token)}
      let! (:balance) {create(:balance, :current)}

      context 'and a transaction' do
        let! (:transaction) {create(:transaction, balance: balance)}

        before do
          get request, headers: {'Api-Token': user.api_token}
        end

        it 'returns the correct general statistics' do
          expected =
              {
                  data: {
                      transactions: {
                          week: 1,
                          month: 1,
                          total: 1,
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
        let! (:transaction) {create(:transaction, balance: balance)}

        before do
          transaction.liked_by user

          get request, headers: {'Api-Token': user.api_token}
        end

        it 'returns the correct general statistics' do
          expected =
              {
                  data: {
                      transactions: {
                          week: 1,
                          month: 1,
                          total: 1,
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
        get request, headers: {'Api-Token': 'invalid api-token'}
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

  describe 'GET api/v1/statistics/user' do
    let (:request) {'/api/v1/statistics/user'}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}

      let! (:balance) {create(:balance, :current)}

      context 'and a transaction sent by the user' do
        let! (:transaction) {create(:transaction, balance: balance, sender: user)}

        before do
          get request, headers: {'Api-Token': user.api_token}
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
        let! (:transaction) {create(:transaction, balance: balance, receiver: user)}

        before do
          get request, headers: {'Api-Token': user.api_token}
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
        get request, headers: {'Api-Token': 'invalid api-token'}
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

  describe 'GET api/v1/statistics/graph' do
    let (:request) {'/api/v1/statistics/graph'}

    context 'with a valid api-token' do
      let (:user) {create(:user, :api_token)}
      let! (:balance) {create(:balance, :current)}

      context 'and a transaction sent in this month' do
        let! (:transaction) {create(:transaction, balance: balance)}

        before do
          get request, headers: {'Api-Token': user.api_token}
        end

        it 'returns the correct graph statistics' do
          expected =
              {
                  data: {
                      "#{month_by_months_ago(0)}": {
                          transactions: 1,
                          kudos: 100
                      },
                      "#{month_by_months_ago(1)}": {
                          transactions: 0,
                          kudos: 0
                      },
                      "#{month_by_months_ago(2)}": {
                          transactions: 0,
                          kudos: 0
                      },
                      "#{month_by_months_ago(3)}": {
                          transactions: 0,
                          kudos: 0
                      },
                      "#{month_by_months_ago(4)}": {
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
        let! (:transaction) {create(:transaction, balance: balance, created_at: 3.months.ago)}

        before do
          get request, headers: {'Api-Token': user.api_token}
        end

        it 'returns the correct graph statistics' do
          expected =
              {
                  data: {
                      "#{month_by_months_ago(0)}": {
                          transactions: 0,
                          kudos: 0
                      },
                      "#{month_by_months_ago(1)}": {
                          transactions: 0,
                          kudos: 0
                      },
                      "#{month_by_months_ago(2)}": {
                          transactions: 0,
                          kudos: 0
                      },
                      "#{month_by_months_ago(3)}": {
                          transactions: 1,
                          kudos: 100
                      },
                      "#{month_by_months_ago(4)}": {
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
        get request, headers: {'Api-Token': 'invalid api-token'}
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