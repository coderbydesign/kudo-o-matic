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

FactoryBot.define do
  factory :activity do
    name "getting me coffee"
  end
end

