class Api::V1::BalanceResource < Api::V1::BaseResource
  attributes :name, :current, :created_at, :updated_at
  filters :name, :current, :created_at, :updated_at
  has_many :transactions
end
