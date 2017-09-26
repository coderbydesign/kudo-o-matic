class Api::V1::GoalResource < JSONAPI::Resource
  primary_key :id
  attributes :achieved_on, :name, :amount
  filters :name, :amount
  has_one :balance
end
