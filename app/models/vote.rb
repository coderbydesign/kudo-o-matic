# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  votable_type :string
#  votable_id   :integer
#  voter_type   :string
#  voter_id     :integer
#  vote_flag    :boolean
#  vote_scope   :string
#  vote_weight  :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Vote < ActiveRecord::Base
  belongs_to :user_voter, class_name: 'User', foreign_key: 'voter_id'
  belongs_to :transaction_votable, class_name: 'Transaction', foreign_key: 'votable_id'

  def self.all_for_user(user)
    Vote.where(voter_id: user.id).order('created_at desc')
  end
end
