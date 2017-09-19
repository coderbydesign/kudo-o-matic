# Preview all emails at http://localhost:3000/rails/mailers/transaction_mailer
class TransactionMailerPreview < ActionMailer::Preview
  def new_transaction
    transaction = Transaction.last
    user = User.where.not(email:"").first
    TransactionMailer.preview_new_transaction(transaction, user)
  end
end
