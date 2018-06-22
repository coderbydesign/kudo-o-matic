class Api::V2::GoalsController < Api::V2::ApiController
  def next
    # redirect_to api_v2_goal_path(Goal.next(current_team.id))
    goal = Goal.next(current_team.id)
    goal_resource = JSONAPI::ResourceSerializer.new(Api::V2::GoalResource).serialize_to_hash(
        Api::V2::GoalResource.new(goal, nil)
    )
    render json: goal_resource
  end

  def previous
    previous_goal = Goal.previous(current_team.id)

    if !previous_goal.id.nil?
      goal_resource = JSONAPI::ResourceSerializer.new(Api::V2::GoalResource).serialize_to_hash(
          Api::V2::GoalResource.new(previous_goal, nil)
      )
      render json: goal_resource
    else
      error_object_overrides = {title: 'Previous goal record not found', detail: 'There is no previous goal record.'}
      errors = JSONAPI::Exceptions::RecordNotFound.new(nil, error_object_overrides).errors
      render_errors(errors)
    end
  end
end
