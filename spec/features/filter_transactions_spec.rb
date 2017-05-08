require 'rails_helper'


RSpec.feature "Filter transactions", type: :feature do
  let!(:prev_goal) { create :goal, :achieved, name: "Painting lessons", amount: 100 }
  let!(:next_goal) { create :goal, name: "Paintball", amount: 1500 }
  let(:activity) { Activity.create name: 'Helping with RSpec' }
  let(:user) { User.create name: 'Pascal', avatar_url: '/kabisa_lizard.png' }
  let(:user_2) { User.create name: 'John User', avatar_url: '/kabisa_lizard.png' }
  let(:balance) { create :balance, :current }
  let!(:transaction) { Transaction.create sender: user_2, receiver: user, activity: activity, amount: 5, balance: balance}
  let!(:transaction_2) { Transaction.create sender: user_2, receiver: user, activity: activity, amount: 10, balance: balance}
  let!(:transaction_3) { Transaction.create sender: user, receiver: user_2, activity: activity, amount: 10, balance: balance}


  before do
    visit '/sign_in'
    click_link 'Sign in with Google Apps'

    expect(current_path).to eql('/')
  end

  it 'Displays my send transactions' do
    @send_transactions = Transaction.where(sender: user_2)

    find('.send').click
    within '.timeline-container' do
      expect(@send_transactions.count).to eq(2)
    end
  end

  it 'Displays my received transactions' do
    @received_transactions = Transaction.where(receiver: user_2)
    find('.received').click
    within '.timeline-container' do
      expect(@received_transactions.count).to eq(1)
    end
  end

  it 'Displays all my transactions' do
    @all_transactions = Transaction.where(sender: user_2).or(Transaction.where(receiver: user_2))
    find('.send').click
    find('.received').click
    within '.timeline-container' do
      expect(@all_transactions.count).to eq(3)
    end
  end

  it 'Displays a message that there is nothing to show yet' do

  end
end