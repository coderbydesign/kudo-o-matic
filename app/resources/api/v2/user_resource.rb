class Api::V2::UserResource < Api::V2::BaseResource
  attributes :name, :email, :avatar_url, :admin
  filters :name, :email, :avatar_url, :admin
  has_many :sent_transactions
  has_many :received_transactions
end
