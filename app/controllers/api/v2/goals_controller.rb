class Api::V2::GoalsController < Api::V2::ApiController
  def next
    redirect_to api_v2_goal_path(Goal.next(@current_team_id))
  end

  def previous
    previous_goal = Goal.previous(@current_team_id)

    if !previous_goal.id.nil?
      redirect_to api_v2_goal_path(previous_goal)
    else
      error_object_overrides = {title: 'Previous goal record not found', detail: 'There is no previous goal record.'}
      errors = JSONAPI::Exceptions::RecordNotFound.new(nil, error_object_overrides).errors
      render_errors(errors)
    end
  end
end
