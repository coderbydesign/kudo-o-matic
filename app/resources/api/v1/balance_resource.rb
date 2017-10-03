class Api::V1::BalanceResource < Api::V1::BaseResource
  attributes :name, :current
  filters :name, :current
  has_many :transactions
end
