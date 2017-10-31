require "rails_helper"

RSpec.describe TransactionMailer, type: :mailer do
  context 'new transaction' do
    let!(:prev_goal) { create :goal, :achieved, name: "Painting lessons", amount: 100 }
    let!(:next_goal) { create :goal, name: "Paintball", amount: 1500 }
    let(:balance) { create :balance, :current }
    let(:user) { User.create name: 'John Doe', email:'johndoe@example.com' }
    let(:activity) { create :activity, name: 'Helping me out' }
    let(:transaction) { create :transaction, sender: user, receiver: user, amount: 5, activity: activity, balance: balance }
    let(:mail) {described_class.transaction_email(user, transaction).deliver_now}

    it 'renders the subject' do
      expect(mail.subject).to eq('You just received 5 ₭ from John Doe!')
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

    it 'assigns @transaction' do
      expect(mail.body.encoded).to match(transaction.sender.name)
      expect(mail.body.encoded).to match(transaction.receiver.name)
      expect(mail.body.encoded).to match(transaction.amount.to_s)
      expect(mail.body.encoded).to match(transaction.activity.name)
    end
  end
end
