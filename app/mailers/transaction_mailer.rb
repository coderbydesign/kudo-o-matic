class TransactionMailer < ApplicationMailer
  def self.new_request(transaction)
    @transaction = transaction
    @user = User.where.not(email:"")
    @user.each do |user|
      if user == !transaction.sender
        transaction_email(user, transaction).deliver_later
      end
    end
  end

  def transaction_email(user, transaction)
    @transaction = transaction
    @user = user
    @markdown = Redcarpet::Markdown.new(MdEmoji::Render, :no_intra_emphasis => true)
    mail(to: user.email, subject: 'New Transaction')
  end

  def self.preview_new_request(transaction, user)
    transaction_email(user, transaction)
  end
end
