class ReminderMailer < ApplicationMailer
  def self.new_reminder(user)
    @user = User.where.not(email:"")
    @user.each do |user|
      reminder_email(user).deliver_later
    end
  end

  def reminder_email(user)
    @user = user
    mail(to: user.email, subject: '₭udo Reminder!')
  end

  def self.preview_new_reminder(user)
    reminder_email(user)
  end
end
