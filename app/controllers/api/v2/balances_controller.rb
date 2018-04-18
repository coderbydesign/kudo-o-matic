class Api::V2::BalancesController < Api::V2::ApiController
  def current
    redirect_to api_v2_balance_path(Balance.current)
  end
end
