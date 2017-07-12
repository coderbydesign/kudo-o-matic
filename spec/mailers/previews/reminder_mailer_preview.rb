# Preview all emails at http://localhost:3000/rails/mailers/reminder_mailer
class ReminderMailerPreview < ActionMailer::Preview
  def new_reminder
    user = User.where.not(email:"").first
    ReminderMailer.preview_new_reminder(user)
  end
end
