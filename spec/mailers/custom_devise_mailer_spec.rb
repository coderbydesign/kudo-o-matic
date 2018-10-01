require "rails_helper"

RSpec.describe KudosDeviseMailer, type: :mailer do
  context 'confirmation instruction' do
    let(:user) { User.create name: 'John Doe', email:'johndoe@example.com' }
    let(:mail) {described_class.confirmation_instructions(user, "faketoken", {})}

    it 'renders the subject' do
      expect(mail.subject).to eq('Confirmation instructions')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'sends the email' do
      expect {mail.deliver_now}.to change {ActionMailer::Base.deliveries.count}.from(0).to(1)
    end

    it 'logo attachment is added' do
      expect(mail.attachments.count).to eq(1)
    end
  end

  context 'reset password instruction' do
    let(:user) { User.create name: 'John Doe', email:'johndoe@example.com' }
    let(:mail) {described_class.reset_password_instructions(user, "faketoken", {})}

    it 'renders the subject' do
      expect(mail.subject).to eq('Reset password instructions')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'sends the email' do
      expect {mail.deliver_now}.to change {ActionMailer::Base.deliveries.count}.from(0).to(1)
    end

    it 'logo attachment is added' do
      expect(mail.attachments.count).to eq(1)
    end
  end

  context 'unlock instruction' do
    let(:user) { User.create name: 'John Doe', email:'johndoe@example.com' }
    let(:mail) {described_class.unlock_instructions(user, "faketoken", {})}

    it 'renders the subject' do
      expect(mail.subject).to eq('Unlock instructions')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'sends the email' do
      expect {mail.deliver_now}.to change {ActionMailer::Base.deliveries.count}.from(0).to(1)
    end

    it 'logo attachment is added' do
      expect(mail.attachments.count).to eq(1)
    end
  end
end
