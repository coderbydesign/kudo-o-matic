class UserMailer < ApplicationMailer
  def self.new_user(user)
    return if (Rails.env != :test && ENV['GMAIL_USERNAME'] == nil)
    return unless user.email != ""
    welcome_email(user).deliver_later
  end

  def welcome_email(user)
    @user = user
    mail(to: user.email, subject: 'Welcome!')
  end

  def self.preview_new_user(user)
    welcome_email(user)
  end
end
