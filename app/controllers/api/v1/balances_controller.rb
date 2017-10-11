class Api::V1::BalancesController < Api::V1::ApiController
  def current
    redirect_to api_v1_balance_path(Balance.current)
  end
end
