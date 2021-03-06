require 'rails_helper'

RSpec.describe GoalMailer, type: :mailer do
  context 'new goal reached' do
    let(:team) { create :team }
    let(:balance) { Balance.current(team) }
    let!(:prev_goal) {create :goal, :achieved, name: "Painting lessons", amount: 100, balance_id: balance.id}
    let!(:next_goal) {create :goal, name: "Paintball", amount: 1500, balance_id: balance.id}
    let(:user) {User.create name: 'John Doe', email: 'johndoe@example.com'}
    let(:mail) {described_class.goal_email(user, team, prev_goal)}

    before do
      team.add_member(user)
    end

    it 'renders the subject' do
      expect(mail.subject).to eq("Goal 'Painting lessons' is reached! \u{1f389}")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['example@mail.com'])
    end

    it 'assigns the previous goal' do
      expect(mail.body.encoded).to match(prev_goal.name)
    end

    it 'sends the email' do
      expect {mail.deliver_now}.to change {ActionMailer::Base.deliveries.count}.from(0).to(1)
    end

    it 'logo attachment is added' do
      expect(mail.attachments.count).to eq(1)
    end
  end
end
