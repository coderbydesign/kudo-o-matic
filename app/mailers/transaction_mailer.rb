class TransactionMailer < ApplicationMailer
  def transaction_email(transaction)
    @transaction = transaction
    @url = root_url
    if @transaction.receiver.present? && !@transaction.receiver.email.blank?
      if @transaction.receiver.name == ENV['COMPANY_USER']
        User.where.not(email: nil).each do |user|
          mail(to: user.email, subject: "You received ₭udo's")
        end
      else
        mail(to: @transaction.receiver.email, subject: "You received ₭udo's")
      end

    end

  end
end
