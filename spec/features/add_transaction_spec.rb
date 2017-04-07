require 'rails_helper'

RSpec.feature "Add a transaction", type: :feature do
  let!(:prev_goal) { create :goal, :achieved, name: "Painting lessons", amount: 500 }
  let!(:next_goal) { create :goal, name: "Paintball", amount: 1500 }

  let!(:balance) { create :balance, :current, amount: 1342 }

  before do
    visit '/sign_in'
    click_link 'Sign in with Google Apps'
  end

  it 'creates and shows the new transaction' do
    visit new_transaction_path

    # fill_in 'transaction_sender', with: 'William'
    fill_in 'transaction_receiver_name', with: 'Harry'
    fill_in 'transaction_activity_name', with: 'helping me out'
    fill_in 'transaction_amount', with: '99'
    click_button 'send-kudos-button'

    expect(current_path).to eql('/')

    within '.timeline-container' do
      expect(page).to have_content("+99 ₭ to Harry for helping me out")
    end

    within '.chart.chart--kudo.js-chart' do
      # 1342 + 99 = 1441
      expect(page).to have_content("1.441 ₭")
    end
  end
end
