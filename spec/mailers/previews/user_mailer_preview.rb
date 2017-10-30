# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def new_user
    user = User.where.not(email: '').first

    UserMailer.welcome_email(user)
  end
end
