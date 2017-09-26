class Api::V1::BalanceResource < JSONAPI::Resource
  primary_key :id
  attributes :current, :name
end
