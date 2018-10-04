# == Schema Information
#
# Table name: goals
#
#  id          :integer          not null, primary key
#  name        :string(32)
#  amount      :integer
#  achieved_on :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  balance_id  :integer
#

FactoryBot.define do
  factory :goal do
    name "Drinks"
    amount 100
    achieved_on nil

    trait :achieved do
      achieved_on { 30.days.ago }
    end

  end
end

