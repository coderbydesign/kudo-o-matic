class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :database_authenticatable, :registerable,
  # :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable

  has_many :sent_transactions,      class_name: "Transaction", foreign_key: :sender_id
  has_many :received_transactions,  class_name: "Transaction", foreign_key: :receiver_id

  def to_s
    name
  end

end
