# Preview all emails at http://localhost:3000/rails/mailers/goal_mailer
class GoalMailerPreview < ActionMailer::Preview
  def new_goal
    team = Team.first
    goal = Goal.previous(team)
    user = User.where.not(email: '').first

    GoalMailer.goal_email(user, team, goal)
  end
end
