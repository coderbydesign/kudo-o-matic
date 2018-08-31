# == Schema Information
#
# Table name: activities
#
#  id               :integer          not null, primary key
#  name             :text
#  suggested_amount :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Activity < ActiveRecord::Base
  has_many :transactions
  acts_as_votable
  def to_s
    name
  end

end
