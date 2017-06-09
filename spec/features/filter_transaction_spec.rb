require 'rails_helper'


RSpec.feature "Filter a transaction", type: :feature do
  let!(:prev_goal) { create :goal, :achieved, name: "Painting lessons", amount: 100 }
  let!(:next_goal) { create :goal, name: "Paintball", amount: 1500 }
  let(:activity) { Activity.create name: 'Helping with RSpec' }
  let(:user) { User.create name: 'Pascal', avatar_url: '/kabisa_lizard.png' }
  let(:balance) { create :balance, :current }
  let!(:transaction) { Transaction.create sender: user, receiver: user, activity: activity, amount: 5, balance: balance}

  before do
    visit '/sign_in'
    click_link 'Log in with Google+'

    expect(current_path).to eql('/')
  end

  it 'has a 200 status code' do
    find('.userstatistics.send-transactions', :first).click

    assert_respond_to(200)

  end
end