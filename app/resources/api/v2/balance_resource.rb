class Api::V2::BalanceResource < Api::V2::BaseResource
  attributes :name, :current, :amount
  filters :name, :current, :amount
  has_many :transactions

  def amount
    @model.amount
  end
end
