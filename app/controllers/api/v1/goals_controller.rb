class Api::V1::GoalsController < Api::V1::ApiController
  def next
    redirect_to api_v1_goal_path(Goal.next)
  end

  def previous
    previous_goal = Goal.previous

    if !previous_goal.id.nil?
      redirect_to api_v1_goal_path(previous_goal)
    else
      error_object_overrides = {title: 'Previous goal record not found', detail: 'There is no previous goal record.'}
      errors = JSONAPI::Exceptions::RecordNotFound.new(nil, error_object_overrides).errors
      render_errors(errors)
    end
  end
end
