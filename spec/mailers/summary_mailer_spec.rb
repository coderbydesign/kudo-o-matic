require "rails_helper"

RSpec.describe SummaryMailer, type: :mailer do
  context 'new summary' do
    let!(:prev_goal) {create :goal, :achieved, name: "Painting lessons", amount: 100}
    let!(:next_goal) {create :goal, name: "Paintball", amount: 1500}
    let!(:team) { create :team}
    let!(:balance) {team.balances.first}
    let!(:user) {User.create name: 'John Doe', email: 'johndoe@example.com'}
    let(:activity) {create :activity, name: 'Helping me out'}
    let(:transaction) {create :transaction, sender: user, receiver: user, amount: 5, activity: activity, balance: balance}
    let(:mail) {described_class.summary_email(user, team)}

    it 'renders the subject' do
      expect(mail.subject).to eq('Weekly ₭udo summary!')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['example@mail.com'])
    end

    it 'sends the email' do
      expect {mail.deliver_now}.to change {ActionMailer::Base.deliveries.count}.from(0).to(1)
    end

    it 'logo attachment is added' do
      expect(mail.attachments.count).to eq(1)
    end
  end
end
