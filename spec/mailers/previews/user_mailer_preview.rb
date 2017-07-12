# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def new_user
    user = User.first
    UserMailer.preview_new_user(user)
  end
end
