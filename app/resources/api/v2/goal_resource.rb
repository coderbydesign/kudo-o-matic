class Api::V2::GoalResource < Api::V2::BaseResource
  attributes :name, :amount, :achieved_on
  filters :name, :amount, :achieved_on
  has_one :balance
end
