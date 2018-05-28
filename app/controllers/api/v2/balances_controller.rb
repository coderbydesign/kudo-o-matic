class Api::V2::BalancesController < Api::V2::ApiController
  def current
    redirect_to api_v2_balance_path(Balance.current(current_team.id))
  end
end
