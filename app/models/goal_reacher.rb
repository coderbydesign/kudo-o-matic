class GoalReacher
  def self.check!
    if Balance.current.amount >= Goal.next.amount
      Goal.next.achieve!
      SlackNotifications.new(self).send_goal_achieved
      # Transaction.goal_reached_transaction
    end
  end
end
