class Api::V1::GoalsController < Api::V1::ApiController
  def next_amount
    render json: {data: {'next_amount': Goal.next.amount}}
  end

  def next_name
    render json: {data: {'next_name': Goal.next.name}}
  end
end
