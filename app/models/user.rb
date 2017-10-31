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
  has_many :votes, foreign_key: 'voter_id'

  def self.from_omniauth(access_token)
    data = access_token.info

    email_address = data['email']
    email_domain = extract_email_domain(email_address)
    return if email_domain_not_allowed?(email_domain)

    existing_user = User.exists? uid: access_token.uid

    user = User.where(uid: access_token.uid).first_or_create(
        provider: access_token.provider,
        uid: access_token.uid,
        name: data['name'],
        email: email_address,
        avatar_url: data['image'],
        mail_notifications: true
    )

    unless existing_user
      UserMailer.new_user(user)
    end

    user
  end

  def self.from_api_token_request(params)
    email_domain = extract_email_domain(params['email'])
    if email_domain_not_allowed?(email_domain)
      error_object_overrides = {title: 'Invalid email domain', detail: "Email domain #{email_domain} is not allowed."}
      error = Api::V1::UnauthorizedError.new(error_object_overrides)
      raise error
    end

    existing_user = User.exists? uid: params['uid']

    user = User.where(uid: params['uid']).first_or_create(params.except(:jwt_token))

    if user.deactivated?
      error_object_overrides = {title: 'Deactivated user account', detail: "User #{user.name} is deactivated."}
      error = Api::V1::UnauthorizedError.new(error_object_overrides)
      raise error
    end

    user.update(mail_notifications: true, api_token: generate_unique_api_token)

    unless existing_user
      UserMailer.new_user(user)
    end

    user
  end

  def first_name
    name.split(' ')[0]
  end

  def picture_url
    avatar_url || '/no-picture-icon.jpg'
  end

  def deactivate
    transaction do
      update(deactivated_at: DateTime.now, api_token: nil)
      ensure_an_admin_remains
    end
  end

  def reactivate
    update(deactivated_at: nil)
  end

  def deactivated?
    !deactivated_at.nil?
  end

  # overridden Devise method that checks the soft delete timestamp on authentication
  def active_for_authentication?
    super && !deactivated_at
  end

  def to_s
    name
  end

  private

  def ensure_an_admin_remains
    if User.where(admin: true, deactivated_at: nil).count < 1
      raise "Last administrator can't be removed from the system"
    end
  end

  def self.extract_email_domain(email_address)
    email_address.split('@')[1]
  end

  def self.email_domain_not_allowed?(email_domain)
    email_domain != ENV.fetch('DEVISE_DOMAIN', 'gmail.com')
  end

  def self.generate_unique_api_token
    api_token = SecureRandom.urlsafe_base64
    # recursively call this function to ensure that a unique api token is generated
    generate_unique_api_token if User.exists?(api_token: api_token)
    api_token
  end
end
