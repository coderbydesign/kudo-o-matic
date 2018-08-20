# frozen_string_literal: true

class Api::V2::BalancesController < Api::V2::ApiController
  def current
    balance = Balance.current(current_team.id)
    balance_resource = JSONAPI::ResourceSerializer.new(Api::V2::BalanceResource).serialize_to_hash(
      Api::V2::BalanceResource.new(balance, nil)
    )
    render json: balance_resource
  end
end
