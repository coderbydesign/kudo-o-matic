class User < ActiveRecord::Base
acts_as_voter
  has_many :sent_transactions,      class_name: "Transaction", foreign_key: :sender_id
  has_many :received_transactions,  class_name: "Transaction", foreign_key: :receiver_id

  def to_s
    name
  end

end
