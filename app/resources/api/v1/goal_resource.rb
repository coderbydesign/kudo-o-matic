class Api::V1::GoalResource < Api::V1::BaseResource
  attributes :name, :amount, :achieved_on, :created_at, :updated_at
  filters :name, :amount, :achieved_on, :created_at, :updated_at
  has_one :balance
end
