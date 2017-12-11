class TransactionMailer < ApplicationMailer
  def self.new_transaction(transaction)
    return if Rails.env == 'test' || ENV['MAIL_USERNAME'] == nil || transaction.receiver.nil?

    receiver = transaction.receiver

    if receiver.email.present? && receiver.transaction_received_mail && receiver.deactivated_at.nil?
      suppress(Exception) {transaction_email(receiver, transaction).deliver_later}
    end

    if receiver.name == ENV['COMPANY_USER']
      User.where.not(email: '').where.not(email: transaction.sender.email).where(deactivated_at: nil).each do |user|
        suppress(Exception) {transaction_email(user, transaction).deliver_later if user.transaction_received_mail}
      end
    end
  end

  def transaction_email(user, transaction)
    @transaction = transaction
    @user = user

    @markdown = Redcarpet::Markdown.new(MdEmoji::Render, no_intra_emphasis: true)

    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/kudo-o-matic-white-mail.png")

    mail(to: user.email, subject: "You just received #{ApplicationController.helpers.number_to_kudos(@transaction.amount)} from #{@transaction.sender.name}!")
  end
end
