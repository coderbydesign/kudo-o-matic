class Api::V1::GoalsController < Api::V1::ApiController
  def next
    @goal = Goal.next

    render :goal
  end

  def previous
    @goal = Goal.previous

    render :goal
  end
end
