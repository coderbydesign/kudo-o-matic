class Api::V1::GoalResource < Api::V1::BaseResource
  attributes :achieved_on, :name, :amount
  filters :name, :amount
  has_one :balance
end
