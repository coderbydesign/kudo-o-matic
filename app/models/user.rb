class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :database_authenticatable, :registerable,
  # :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:google_oauth2]

  has_many :sent_transactions,      class_name: "Transaction", foreign_key: :sender_id
  has_many :received_transactions,  class_name: "Transaction", foreign_key: :receiver_id

  def self.from_omniauth(access_token)
    data = access_token.info

    user = User.where(provider: access_token.provider, uid: access_token.uid).first_or_create!

    user.update(
      name: data["name"],
      email: data["email"],
      avatar_url: data["image"]
    )

    user
  end

  def to_s
    name
  end

end
