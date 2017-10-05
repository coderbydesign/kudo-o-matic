class Api::V1::VoteResource < Api::V1::BaseResource
  attributes :votable_type, :votable_id, :voter_type, :voter_id, :vote_flag, :vote_scope, :vote_weight
  filters :votable_type, :votable_id, :voter_type, :voter_id, :vote_flag, :vote_scope, :vote_weight
  has_one :user_voter
  has_one :transaction_votable
end
