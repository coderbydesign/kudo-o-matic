class GoalReacher
  def self.check!
    if Balance.current.amount >= Goal.next.amount
      Goal.next.achieve!
      SlackService.instance.send_goal_reached
      GoalMailer.new_goal(Goal.previous)
      # Transaction.goal_reached_transaction
    end
  end
end
