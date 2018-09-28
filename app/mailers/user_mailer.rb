class UserMailer < ApplicationMailer
  def self.new_user(user)
    return if Rails.env == 'test' || ENV['MAIL_USERNAME'].blank? || user.email.blank?

    suppress(Exception) {welcome_email(user).deliver_later}
  end

  def invite_email(email, team)
    @team = team

    mail(to: email, subject: "You've been invited to join the Kudos-o-Matic")
  end

  def welcome_email(user)
    @user = user

    mail(to: user.email, subject: 'Welcome to the ₭udo-o-Matic!')
  end

  def export_start_email(user)
    @user = user

    mail(to: user.email, subject: 'Started data export!')
  end

  def export_done_email(user, export)
    @user = user

    @export = export
    mail(to: user.email, subject: 'Data export finished!')
  end
end
