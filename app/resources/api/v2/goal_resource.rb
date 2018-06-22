class Api::V2::GoalResource < Api::V2::BaseResource
  model_name 'Goal'

  attributes :name, :amount, :achieved_on
  filters :name, :amount, :achieved_on
  has_one :balance
end
