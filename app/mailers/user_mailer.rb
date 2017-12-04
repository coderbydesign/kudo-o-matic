class UserMailer < ApplicationMailer
  def self.new_user(user)
    return if Rails.env == 'test' || ENV['MAIL_USERNAME'] == nil || user.email.blank?

    welcome_email(user).deliver_later
  end

  def welcome_email(user)
    @user = user

    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/kudo-o-matic-white-mail.png")

    mail(to: user.email, subject: 'Welcome to the ₭udo-o-Matic!')
  end
end
