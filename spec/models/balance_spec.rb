require 'rails_helper'

describe Balance, type: :model do
  let(:activity) { Activity.create name: 'Helping with RSpec' }
  let(:activity_2) { Activity.create name: 'Helping with Capybara' }
  let(:user) { User.create name: 'Pascal', avatar_url: '/kabisa_lizard.png' }
  let(:balance) { create :balance, :current, created_at: '2016-12-31 22:00:00' }
  let(:balance_2) { create :balance, current: false }
  let(:balance_3) { create :balance, :current, created_at: '2016-12-31 23:00:00' }
  let!(:transaction) { Transaction.create sender: user, receiver: user, activity: activity, amount: 5, balance: balance, created_at: '2016-12-31 22:00:00'}
  let!(:transaction_2) { Transaction.create sender: user, receiver: user, activity: activity_2, amount: 10, balance: balance, created_at: '2016-12-31 23:00:00'}

  before do
    Timecop.freeze(Time.new(2017,01,01))
  end

  describe '#time_left' do
    it 'calculates the days left until the end of the year' do
      Balance.time_left

      expect(Balance.time_left).to eq("364 day(s) left")
    end
  end

  describe '#amount' do
    it 'calculates the amount of the balance' do
      expect(balance.amount).to eq(15)
    end
  end

  describe '#last_transaction' do
    it 'finds the last transaction' do
      expect(balance.last_transaction).to eq(transaction_2)
    end
  end

  describe '#current' do
    it 'find the first created and current balance' do
      expect(Balance.current).to eq(balance)
    end
  end
end
