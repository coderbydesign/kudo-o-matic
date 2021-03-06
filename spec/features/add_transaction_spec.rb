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
  let!(:transaction) do
    Transaction.create sender: user, receiver: user, activity: activity, amount: 5,
                       balance: balance, team_id: team.id
  end
  let!(:transaction_2) do
    Transaction.create sender: user, receiver: user, activity: activity, amount: 10,
                       balance: balance, team_id: team.id
  end

  before do
    team.add_member(user)
    team.add_member(user_2)
    visit '/sign_in'
    fill_in 'user_email', with: user_2.email
    fill_in 'user_password', with: 'testpass'
    click_button 'Log in'
    expect(current_path).to eql('/kabisa')
    find('.close-welcome').click
    @transactions_before = Transaction.count
  end

  context 'Succesfully created transaction' do
    before do
      fill_in 'transaction_receiver_name', with: 'Harry'
      fill_in 'transaction_activity_name', with: 'helping me out :+1:'
      fill_in 'transaction_amount', with: '99'
      click_button 'send-kudos-button'
    end

    it 'creates and shows the new transaction' do
      expect(Transaction.count).to_not eq(@transactions_before)
      within '.timeline-container' do
        expect(page).to have_css("img[src*='kabisa_lizard.png']")
        expect(page).to have_content('John User gives 99 ₭ to Harry for helping me out')
        expect(page).to have_css("img[src*='plus1-6ba5fab051ddb1e4712f523f1b10164a5d87ffe3f10861f038bd36ebf9e9184f.png']")
      end
    end

    it 'calculates and shows the transaction statistics of the current user' do
      within '.user-statistics-container' do
        expect(page).to have_content('0') # received transactions
        expect(page).to have_content('1') # total and given transactions
      end
    end

    it 'calculates and shows the transaction statistics in general' do
      within '.transaction-statistics' do
        expect(page).to have_content('3')
      end
    end

    it 'calculates and shows the new amount of the balance' do
      within '.chart.chart--kudo.js-chart' do
        # 5 + 10 + 99 = 114
        expect(page).to have_content('114 ₭')
      end
    end

    it 'calculates and shows the percentage in the balance' do
      def helper
        @helper ||= Class.new do
          include ActionView::Helpers::NumberHelper
        end.new
      end

      @number = ((Balance.current(team.id).amount.to_f - Goal.previous(team.id).amount.to_f) / (Goal.next(team.id).amount.to_f - Goal.previous(team.id).amount.to_f)) * 100
      @balance_percentage = helper.number_to_percentage(@number, precision: 0)
      within('.percentage') do
        expect(page).to have_content(@balance_percentage)
      end
    end
  end

  context 'Create a transaction with an image' do
    it 'should be valid' do
      image = Transaction.new sender: user, receiver: user, activity: activity, amount: 10, balance: balance, image: File.new(Rails.root + 'spec/fixtures/images/rails.png', team: team)
      expect(image).to be_valid
    end

    it 'should be invalid' do
      image = Transaction.new sender: user, receiver: user, activity: activity, amount: 10, balance: balance, image: File.new(Rails.root + 'spec/fixtures/images/blank.txt', team: team)
      expect(image).to_not be_valid
    end
  end

  context 'Failed to create transaction' do
    context 'No input' do
      before do
        click_button 'send-kudos-button'
      end

      it 'shows a flash error notice' do
        within '#transaction-errors' do
          expect(page).to have_css('.error-message')
        end
      end

      it "doesn't create a new transaction" do
        @transactions_before = Transaction.count
        expect(Transaction.count).to eq(@transactions_before)
      end
    end

    context 'No receiver' do
      before do
        fill_in 'transaction_activity_name', with: 'helping me out'
        fill_in 'transaction_amount', with: '50'
        click_button 'send-kudos-button'
      end

      it 'creates and shows a new transaction' do
        expect(Transaction.count).to_not eq(@transactions_before)

        within '.timeline-container' do
          expect(page).to have_content('John User gives 50 ₭ to for helping me out')
        end
      end
    end

    context 'No amount input' do
      before do
        fill_in 'transaction_receiver_name', with: user
        fill_in 'transaction_activity_name', with: 'helping me out'
        click_button 'send-kudos-button'
      end

      it 'shows a flash error notice' do
        within '#transaction-errors' do
          expect(page).to have_css('.error-message')
        end
      end

      it "doesn't create a new transaction" do
        expect(Transaction.count).to eq(@transactions_before)
      end
    end

    context 'No activity input' do
      before do
        fill_in 'transaction_receiver_name', with: user
        fill_in 'transaction_amount', with: '50'
        click_button 'send-kudos-button'
      end

      it 'shows a flash error notice' do
        within '#transaction-errors' do
          expect(page).to have_css('.error-message')
        end
      end

      it "doesn't create a new transaction" do
        @transactions_before = Transaction.count
        expect(Transaction.count).to eq(@transactions_before)
      end
    end
  end

  context 'Non-personal-kudos' do
    before do
      fill_in 'transaction_receiver_name', with: 'My awesome colleagues'
      fill_in 'transaction_activity_name', with: 'helping me solve this puzzle'
      fill_in 'transaction_amount', with: '20'
      click_button 'send-kudos-button'
    end

    it 'displays the group but does not create an new user' do
      @users_before = User.count
      expect(User.count).to eq(@users_before)
      expect(page).to have_css('.receivername', text: 'My awesome colleagues')
      expect(page).to have_css('.activityname', text: 'helping me solve this puzzle')
    end
  end
end
