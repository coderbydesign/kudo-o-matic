class GoalMailer < ApplicationMailer
  def self.new_goal(goal)
    return if Rails.env == 'test' || ENV['MAIL_USERNAME'] == nil

    User.where.not(email: '').where(mail_notifications: true).each do |user|
      goal_email(user, goal).deliver_later
    end
  end

  def goal_email(user, goal)
    @goal = goal
    @user = user

    attachments.inline['logo.png'] = File.read("#{Rails.root}/app/assets/images/kudo-o-matic-white-mail.png")

    mail(to: user.email, subject: "Goal '#{Goal.previous.name}' is reached! \u{1f389}")
  end
end
