class Api::V2::UserResource < Api::V2::BaseResource
  attributes :name, :email, :avatar_url, :admin
  filters :name, :email, :avatar_url, :admin
  has_many :sent_transactions
  has_many :received_transactions

  def self.records(options = {})
    context = options[:context]

    # Return all team members except the current user
    context[:current_team].users.where.not(id: context[:api_user].id)
  end
end
