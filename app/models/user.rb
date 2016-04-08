class User < ActiveRecord::Base

  has_many :sent_transactions,      class_name: "Transaction", foreign_key: :from_id
  has_many :received_transactions,  class_name: "Transaction", foreign_key: :to_id

  def to_s
    name
  end

end
