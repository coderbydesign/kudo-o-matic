class Api::V1::ActivityResource < Api::V1::BaseResource
  attributes :name, :suggested_amount
  filters :name, :suggested_amount
  has_many :transactions
end
