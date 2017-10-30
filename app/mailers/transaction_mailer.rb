class TransactionMailer < ApplicationMailer
  def self.new_transaction(transaction)
    return if Rails.env == 'test' || ENV['MAIL_USERNAME'] == nil

    user = transaction.receiver

    return if user.nil?

    if user.email != '' && user.mail_notifications == true
      transaction_email(user, transaction).deliver_later
    end
  end

  def transaction_email(user, transaction)
    @transaction = transaction
    @user = user

    @markdown = Redcarpet::Markdown.new(MdEmoji::Render, :no_intra_emphasis => true)

    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/kudo-o-matic-white-mail.png")

    mail(to: user.email, subject: "You just received #{ApplicationController.helpers.number_to_kudos(@transaction.amount)} from #{@transaction.receiver.name}!")
  end
end
