# == Schema Information
#
# Table name: balances
#
#  id         :integer          not null, primary key
#  name       :string
#  current    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :integer
#

FactoryBot.define do
  factory :balance do
    name "My Balance"

    trait :current do
      current true
    end
  end
end
