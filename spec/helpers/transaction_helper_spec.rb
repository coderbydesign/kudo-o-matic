require 'rails_helper'
include ERB::Util
# require 'redcarpet'
# require 'md_emoji/render'

describe TransactionsHelper do
  let!(:prev_goal) { create :goal, amount: 500 }
  let!(:next_goal) { create :goal, amount: 1000 }
  let(:activity) { Activity.create name: 'Helping with RSpec' }
  let(:user) {
    User.create name: 'Pascal', email: 'pascal@example.com',
                password: 'testpass', password_confirmation: 'testpass',
                confirmed_at: Time.now, avatar_url: '/kabisa_lizard.png'
  }
  let(:user_2) {
    User.create name: 'Pascal', email: 'pascal2@example.com',
                password: 'testpass', password_confirmation: 'testpass',
                confirmed_at: Time.now, avatar_url: '/kabisa_lizard.png'
  }
  let(:user_3) {
    User.create name: 'Pascal', email: 'pascal3@example.com',
                password: 'testpass', password_confirmation: 'testpass',
                confirmed_at: Time.now, avatar_url: '/kabisa_lizard.png'
  }
  let(:user_4) {
    User.create name: 'Pascal', email: 'pascal4@example.com',
                password: 'testpass', password_confirmation: 'testpass',
                confirmed_at: Time.now, avatar_url: '/kabisa_lizard.png'
  }
  let(:user_5) {
    User.create name: 'Pascal', email: 'pascal5@example.com',
                password: 'testpass', password_confirmation: 'testpass',
                confirmed_at: Time.now, avatar_url: '/kabisa_lizard.png'
  }
  let(:user_6) {
    User.create name: 'Pascal', email: 'pascal6@example.com',
                password: 'testpass', password_confirmation: 'testpass',
                confirmed_at: Time.now, avatar_url: '/kabisa_lizard.png'
  }
  let(:user_7) {
    User.create name: 'Pascal', email: 'pascal7@example.com',
                password: 'testpass', password_confirmation: 'testpass',
                confirmed_at: Time.now, avatar_url: '/kabisa_lizard.png'
  }
  let(:balance) { create :balance, :current }
  let!(:transaction) {
    Transaction.create sender: user, receiver: user,
                       activity: activity, amount: 100, balance: balance
  }
  let!(:transaction_2) {
    Transaction.create sender: user, receiver: user,
                       activity: activity, amount: 100, balance: balance
  }
  let!(:transaction_3) {
    Transaction.create sender: user, receiver: user,
                       activity: activity, amount: 500, balance: balance
  }

  context 'calculate percentage until next goal' do
    it 'returns the completion percentage' do
      expect(percentage_next_goal).to eq('70%')
    end
  end

  context 'displays the number of likes' do
    before do
      transaction.liked_by user
      transaction.liked_by user_2
      transaction.liked_by user_3
      transaction.liked_by user_4
      transaction.liked_by user_5
      transaction.liked_by user_6
      transaction.liked_by user_7
    end

    it 'calculates the likes' do
      expect(number_of_likes(transaction)).to eq(7)
    end

    it 'lists the users > 5 in a tooltip' do
      expect(list_others_tooltip(transaction)).to eq('and 2 others')
    end

    it 'lists the users who liked' do
      expect(display_likes(transaction)).to eq('+7 ₭ by Pascal and 6 others')
    end
  end

  context 'renders the activity' do
    it 'displays the activity correct' do
      markdown = Redcarpet::Markdown.new(MdEmoji::Render, :no_intra_emphasis => true)
      expect(render_activity(transaction, markdown)).to eq('Helping with RSpec')
    end
  end
end
