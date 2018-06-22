# frozen_string_literal: true

class Api::V2::GoalsController < Api::V2::ApiController
  def next
    goal = Goal.next(current_team.id)
    render_goal goal
  end

  def previous
    previous_goal = Goal.previous(current_team.id)

    if !previous_goal.id.nil?
      render_goal previous_goal
    else
      error_object_overrides = { title: 'Previous goal record not found', detail: 'There is no previous goal record.' }
      errors = JSONAPI::Exceptions::RecordNotFound.new(nil, error_object_overrides).errors
      render_errors(errors)
    end
  end

  private

  def render_goal(goal)
    goal_resource = JSONAPI::ResourceSerializer.new(Api::V2::GoalResource).serialize_to_hash(
      Api::V2::GoalResource.new(goal, nil)
    )
    render json: goal_resource, status: :ok
  end
end
