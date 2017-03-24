require 'rails_helper'

describe Transaction do
  before(:all) do
    ActiveRecord::Base.skip_callbacks = true
  end

  after(:all) do
    ActiveRecord::Base.skip_callbacks = false
  end

  context 'given no receiver' do
    it 'extracts the receiver name from the activity', callbacks: false do
      activity = Activity.create(name: 'Pascal for: Helping with RSpec')
      transaction = Transaction.create(activity: activity, amount: 5)
      expect(transaction.receiver_name).to eq('Pascal')
      expect(transaction.activity_name).to eq('Helping with RSpec')
      expect(transaction.receiver_image).to eq('/kabisa_lizard.png')
    end
  end

  context 'given a receiver' do
    let(:activity) { Activity.create name: 'Helping with RSpec' }
    let(:user) { User.create name: 'Pascal', avatar_url: '/kabisa_lizard.png' }
    let(:transaction) { Transaction.create receiver: user, activity: activity, amount: 5 }

    it 'returns the receiver name and activity', callbacks: false do
      expect(transaction.receiver_name).to eq(user.name)
      expect(transaction.activity_name).to eq(transaction.activity.name)
      expect(transaction.receiver_image).to eq(user.avatar_url)
    end
  end

  context 'given a transaction is deleted', callbacks: false do
    let(:balance) { Balance.create name: 'Current balance', amount: 18, current: true }
    let(:transaction) { Transaction.create amount: 6 }

    it 'subtracts the amount of the transaction from the balance' do
      expect(balance.amount - transaction.amount).to eq(12)
    end
  end
end
