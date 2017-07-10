# Preview all emails at http://localhost:3000/rails/mailers/transaction_mailer
class TransactionMailerPreview < ActionMailer::Preview
  def transaction_email
    TransactionMailer.transaction_email(User.first)
  end
end
