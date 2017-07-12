require "rails_helper"

RSpec.describe ReminderMailer, type: :mailer do
  context 'new reminder' do
    let!(:prev_goal) { create :goal, :achieved, name: "Painting lessons", amount: 100 }
    let!(:next_goal) { create :goal, name: "Paintball", amount: 1500 }
    let(:balance) { create :balance, :current }
    let(:user) { User.create name: 'John Doe', email:'johndoe@example.com' }
    let(:mail) { described_class.preview_new_reminder(user).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('₭udo Reminder!')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq([ENV['GMAIL_USERNAME']])
    end

    it 'assigns @user' do
      expect(mail.body.encoded).to match(user.name)
    end
  end
end
