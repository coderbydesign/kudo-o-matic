class Api::V1::BaseResource < JSONAPI::Resource
  abstract

  primary_key :id
end