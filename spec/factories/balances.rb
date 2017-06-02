FactoryGirl.define do
  factory :balance do
    name "My Balance"

    trait :current do
      current true
    end
  end
end
