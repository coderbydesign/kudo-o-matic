class Vote < ActiveRecord::Base
  belongs_to :user_voter, class_name: 'User', foreign_key: 'voter_id'
  belongs_to :transaction_votable, class_name: 'Transaction', foreign_key: 'votable_id'
end
