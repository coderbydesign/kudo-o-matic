class GoalReachedMailer < ApplicationMailer
  def self.new_goal(goal)
    return if (Rails.env != 'test' && ENV['MAIL_USERNAME'] == nil)
    @user = User.where.not(email:"").where(mail_notifications:true)
    @user.each do |user|
      goal_email(user, goal).deliver_later
    end
  end

  def goal_email(user, goal)
    @goal = goal
    @user = user
    @markdown = Redcarpet::Markdown.new(MdEmoji::Render, :no_intra_emphasis => true)
    mail(to: user.email, subject: 'A goal is reached!')
  end

  def self.preview_new_goal(user, goal)
    goal_email(user, goal)
  end
end
