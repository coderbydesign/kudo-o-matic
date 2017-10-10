class Api::V1::BalanceResource < Api::V1::BaseResource
  attributes :name, :current, :amount
  filters :name, :current, :amount
  has_many :transactions

  def amount
    @model.amount
  end
end
