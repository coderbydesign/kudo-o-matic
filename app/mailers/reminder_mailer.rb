class ReminderMailer < ApplicationMailer
  def self.new_reminder
    return if (Rails.env != :test && ENV['GMAIL_USERNAME'] == nil)
    @user = User.where.not(email:"").where(mail_notifications: true)
    @user.each do |user|
      reminder_email(user).deliver_later
    end
  end

  def reminder_email(user)
    @user = user
    mail(to: user.email, subject: '₭udo Reminder!')
  end

  def self.preview_new_reminder
    user = User.where.not(email:"").first
    reminder_email(user)
  end
end
