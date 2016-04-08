class GoalReacher
  def self.check!
    Goal.next.achieve! if Balance.current.amount >= Goal.next.amount
  end
end
