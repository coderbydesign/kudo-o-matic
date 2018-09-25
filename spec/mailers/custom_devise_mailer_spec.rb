require "rails_helper"

RSpec.describe CustomDeviseMailer, type: :mailer do
  context 'new user' do
    let(:user) { User.create name: 'John Doe', email:'johndoe@example.com' }
    let(:mail) {described_class.confirmation_instructions(user, "faketoken", {})}

    # it 'renders the subject' do
    #   expect(mail.subject).to eq('Welcome to the ₭udo-o-Matic!')
    # end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'sends the email' do
      expect {mail.deliver_now}.to change {ActionMailer::Base.deliveries.count}.from(0).to(1)
    end
  end
end
