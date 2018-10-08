# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Add a transaction', type: :feature do
  let(:activity) { Activity.create name: 'Helping with RSpec' }
  let(:team) { create :team }
  let(:user) do
    User.create name: 'Pascal', email: 'pascal@email.com', password: 'testpass',
                password_confirmation: 'testpass', confirmed_at: Time.now,
                avatar_url: '/kabisa_lizard.png', restricted: false
  end
  let(:user_2) do
    User.create name: 'John User', email: 'john@email.com', password: 'testpass',
                password_confirmation: 'testpass', confirmed_at: Time.now,
                avatar_url: '/kabisa_lizard.png', restricted: false
  end
  let(:balance) { create :balance, :current, team_id: team.id }

  before do
    team.add_member(user)
    team.add_member(user_2)
    visit '/sign_in'
    fill_in 'user_email', with: user_2.email
    fill_in 'user_password', with: 'testpass'
    click_button 'Log in'

    expect(current_path).to eql('/kabisa')
  end

  context 'Succesfully deleted transaction' do
    before do
      fill_in 'transaction_receiver_name', with: 'Harry'
      fill_in 'transaction_activity_name', with: 'helping me out :+1:'
      fill_in 'transaction_amount', with: '99'
      click_button 'send-kudos-button'
      @transactions_before = Transaction.count
    end

    it 'Deletes the transaction' do
      click_link 'Delete transaction'
      @transactions_after = Transaction.count
      expect(@transactions_before).to_not eq(@transactions_after)
    end
  end
end


