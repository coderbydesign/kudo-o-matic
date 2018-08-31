# == Schema Information
#
# Table name: fcm_tokens
#
#  id         :integer          not null, primary key
#  token      :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FcmToken < ActiveRecord::Base
  validates :token, uniqueness: true

  belongs_to :user
end
