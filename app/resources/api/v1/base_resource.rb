class Api::V1::BaseResource < JSONAPI::Resource
  abstract

  primary_key :id
  attributes :created_at, :updated_at
  filters :created_at, :updated_at
end