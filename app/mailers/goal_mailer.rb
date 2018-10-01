class GoalMailer < ApplicationMailer
  def self.new_goal(goal, team)
    return if Rails.env == 'test' || ENV['MAIL_USERNAME'].blank?

    team.users.where.not(email: '').where(deactivated_at: nil).each do |user|
      suppress(Exception) {goal_email(user, team, goal).deliver_later if user.goal_reached_mail}
    end
  end

  def goal_email(user, team, goal)
    @goal = goal
    @user = user

    mail(to: user.email, subject: "Goal '#{Goal.previous(team).name}' is reached! \u{1f389}")
  end
end
