class GoalReacher
  def self.check!(team)
    if Balance.current(team).amount >= Goal.next(team).amount
      Goal.next(team).achieve!

      SlackService.instance.send_goal_reached(team)
      FcmService.instance.send_goal_reached
      GoalMailer.new_goal(Goal.previous(team))
    end
  end
end
