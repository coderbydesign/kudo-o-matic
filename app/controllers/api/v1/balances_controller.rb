class Api::V1::BalancesController < Api::V1::ApiController
  def current_amount
    render json: {data: {'current_amount': Balance.current.amount}}
  end
end
