# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    user = User.where.not(email: '').first

    UserMailer.welcome_email(user)
  end

  def invite_email
    user = User.where.not(email: '').first
    team = Team.first

    UserMailer.invite_email(user, team)
  end
end
