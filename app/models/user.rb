class User < ActiveRecord::Base
  after_update :ensure_an_admin_remains

  acts_as_voter
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :database_authenticatable, :registerable,
  # :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:google_oauth2]

  has_many :sent_transactions, class_name: 'Transaction', foreign_key: :sender_id
  has_many :received_transactions, class_name: 'Transaction', foreign_key: :receiver_id
  has_many :votes, class_name: 'Vote', foreign_key: 'voter_id'

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

  def deactivate
    update_attribute(:deactivated_at, DateTime.now)
    ensure_an_admin_remains
  end

  def reactivate
    update_attribute(:deactivated_at, nil)
  end

  def deactivated?
    !deactivated_at.nil?
  end

  # overridden Devise method that checks the soft delete timestamp on authentication
  def active_for_authentication?
    super && !deactivated_at
  end

  private

  def ensure_an_admin_remains
    if User.where(admin: true, deactivated_at: nil).count < 1
      raise "Last administrator can't be removed from the system"
    end
  end

  def self.generate_unique_api_token
    api_token = SecureRandom.urlsafe_base64
    # recursively call this function to ensure that a unique api token is generated
    generate_unique_api_token if User.exists?(api_token: api_token)
    api_token
  end
end
