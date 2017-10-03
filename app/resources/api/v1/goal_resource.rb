class Api::V1::GoalResource < Api::V1::BaseResource
  attributes :name, :amount, :achieved_on
  filters :name, :amount, :achieved_on
  has_one :balance
end
