class Api::V1::UserResource < Api::V1::BaseResource
  attributes :name, :email, :avatar_url, :admin
  filters :name, :email, :avatar_url, :admin
  has_many :sent_transactions
  has_many :received_transactions
end
