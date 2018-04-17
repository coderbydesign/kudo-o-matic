require 'rails_helper'

describe Transaction do
  before(:all) do
    ActiveRecord::Base.skip_callbacks = true
  end

  after(:all) do
    ActiveRecord::Base.skip_callbacks = false
  end

  context 'given no receiver' do
    let(:activity) { Activity.create(name: 'Pascal for: Helping with RSpec') }
    let(:transaction) { Transaction.create activity: activity, amount: 5 }

    it 'extracts the receiver name from the activity', callbacks: false do
      expect(transaction.receiver_name_feed).to eq('Pascal')
    end

    it 'returns the activity name from the receiver', callbacks: false do
      expect(transaction.activity_name_feed).to eq('Helping with RSpec')
    end

    it 'returns the standard no-receiver image', callbacks: false do
      expect(transaction.receiver_image).to eq('/kabisa_lizard.png')
    end
  end

  context 'given a receiver' do
    let(:activity) { Activity.create name: 'Helping with RSpec' }
    let(:user) { User.create name: 'Pascal', avatar_url: '/kabisa_lizard.png' }
    let(:transaction) { Transaction.create receiver: user, activity: activity, amount: 5 }

    it 'returns the receiver name', callbacks: false do
      expect(transaction.receiver_name_feed).to eq(user.name)
    end

    it 'returns the activity name', callbacks: false do
      expect(transaction.activity_name_feed).to eq(transaction.activity.name)
    end

    it 'returns the receiver image', callbacks: false do
      expect(transaction.receiver_image).to eq(user.avatar_url)
    end
  end

  context ' filter transactions' do
    let(:activity) { Activity.create name: 'Helping with RSpec' }
    let(:user) {
      User.create name: 'Pascal', email: 'pascal@example.com',
                  password: 'testpass', password_confirmation: 'testpass',
                  confirmed_at: Time.now, avatar_url: '/kabisa_lizard.png'
    }
    let(:user_2) {
      User.create name: 'John User', email: 'johnuser@example.com',
                  password: 'testpass', password_confirmation: 'testpass',
                  confirmed_at: Time.now, avatar_url: '/kabisa_lizard.png'
    }
    let(:user_3) {
      User.create name: 'John Doe', email: 'johndoe@example.com',
                  password: 'testpass', password_confirmation: 'testpass',
                  confirmed_at: Time.now, avatar_url: '/kabisa_lizard.png'
    }
    let(:balance) { create :balance, :current }
    let(:balance_2) { create :balance }
    let!(:transaction) { Transaction.create sender: user_2, receiver: user, activity: activity, amount: 5, balance: balance }
    let!(:transaction_2) { Transaction.create sender: user_2, receiver: user, activity: activity, amount: 10, balance: balance }
    let!(:transaction_3) { Transaction.create sender: user, receiver: user_2, activity: activity, amount: 10, balance: balance }
    let!(:transaction_4) { Transaction.create sender: user_2, receiver: user_2, activity: activity, amount: 15, balance: balance }

    it 'Displays all my transactions from the current balance' do
      transactions = Transaction.all_for_user(user_2)
      expect(transactions.count).to eq(4)
    end

    it 'Displays my send transactions from the current balance' do
      transactions = Transaction.send_by_user(user_2)

      expect(transactions.count).to eq(3)
    end

    it 'Displays my received transactions from the current balance' do
      transactions = Transaction.received_by_user(user_2)

      expect(transactions.count).to eq(2)
    end

    it 'Displays no transactions' do
      transactions = Transaction.received_by_user(user_3)

      expect(transactions.count).to eq(0)
    end
  end
end
