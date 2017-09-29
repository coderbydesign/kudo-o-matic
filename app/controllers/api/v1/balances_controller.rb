class Api::V1::BalancesController < Api::V1::ApiController
  def current
    @balance = Balance.current
    render :balance
  end
end
