require "rails_helper"

RSpec.describe GoalReachedMailer, type: :mailer do
  context 'new goal reached' do
    let!(:prev_goal) { create :goal, :achieved, name: "Painting lessons", amount: 100 }
    let!(:next_goal) { create :goal, name: "Paintball", amount: 1500 }
    let(:balance) { create :balance, :current }
    let(:user) { User.create name: 'John Doe', email:'johndoe@example.com' }
    let(:mail) { described_class.preview_new_goal(user, prev_goal).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('A goal is reached!')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['example@mail.com'])
    end

    it 'assigns @user' do
      expect(mail.body.encoded).to match(user.name)
    end

    it 'assigns the previous goal' do
      expect(mail.body.encoded).to match(prev_goal.name)
    end
  end
end
