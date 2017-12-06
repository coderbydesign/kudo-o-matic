class FcmToken < ActiveRecord::Base
  validates :token, uniqueness: true

  belongs_to :user
end
