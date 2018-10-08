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
    @transactions_before = Transaction.count
  end

  context 'Succesfully edited transaction' do
    before do
      fill_in 'transaction_receiver_name', with: 'Harry'
      fill_in 'transaction_activity_name', with: 'helping me out :+1:'
      fill_in 'transaction_amount', with: '99'
      attach_file('transaction[image]', Rails.root + 'spec/fixtures/images/rails.png')
      click_button 'send-kudos-button'
      click_link 'Edit transaction'
      # visit "kabisa/transactions/#{Transaction.last.id.to_s}/edit"
      expect(current_path).to eql("/kabisa/transactions/#{Transaction.last.id.to_s}/edit")
    end

    it 'Edits the new transaction' do
      fill_in 'transaction_amount', with: '90'
      click_button 'send-kudos-button'
      expect(Transaction.last.amount).to eq(90)
    end

    it 'Deletes the image' do
      expect(Transaction.last.image_file_name).to_not eq(nil)
      find('#transaction_image_delete_checkbox').click
      click_button 'send-kudos-button'
      expect(Transaction.last.image_file_name).to eq(nil)
    end
  end
end
