# Preview all emails at http://localhost:3000/rails/mailers/goal_reached_mailer
class GoalReachedMailerPreview < ActionMailer::Preview
  def new_goal
    goal = Goal.previous.name
    user = User.where.not(email:"").first
    GoalReachedMailer.preview_new_goal(user, goal)
  end
end
