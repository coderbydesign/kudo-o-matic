class User < ActiveRecord::Base
  acts_as_voter
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :database_authenticatable, :registerable,
  # :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:google_oauth2]

  has_many :sent_transactions, class_name: 'Transaction', foreign_key: :sender_id
  has_many :received_transactions, class_name: 'Transaction', foreign_key: :receiver_id

  def self.from_omniauth(access_token)
    data = access_token.info
    return if data['email'].split('@')[1] != ENV.fetch('DEVISE_DOMAIN', 'gmail.com')

    user = User.where(uid: access_token.uid).first_or_create(
        provider: access_token.provider,
        uid: access_token.uid,
        name: data['name'],
        email: data['email'],
        avatar_url: data['image']
    )

    UserMailer.new_user(user)

    user
  end

  def self.from_api_token_request(params)
    user = User.where(uid: params['uid']).first_or_create(params.except(:jwt_token))
    user.update(api_token: generate_unique_api_token)

    UserMailer.new_user(user)

    user
  end

  def to_s
    name
  end

  def picture_url
    avatar_url || '/no-picture-icon.jpg'
  end

  private

  def self.generate_unique_api_token
    api_token = SecureRandom.urlsafe_base64
    # recursively call this function to ensure that a unique api token is generated
    generate_unique_api_token if User.exists?(api_token: api_token)
    api_token
  end
end
