require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  context 'new transaction' do
    let!(:next_goal) { create :goal, name: "Paintball", amount: 1500 }
    let(:balance) { create :balance, :current }
    let(:user) { User.create name: 'John Doe', email:'johndoe@example.com' }
    let(:mail) {described_class.welcome_email(user)}
    let!(:deliveries_count_before_delivery) {ActionMailer::Base.deliveries.count}

    before do
      mail.deliver_now
    end

    it 'renders the subject' do
      expect(mail.subject).to eq('Welcome to the ₭udo-o-Matic!')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['example@mail.com'])
    end

    it 'assigns @user' do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it 'sends the email' do
      expect(deliveries_count_before_delivery).to be < ActionMailer::Base.deliveries.count
    end
  end
end
