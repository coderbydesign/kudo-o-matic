FactoryGirl.define do
  factory :goal do
    name "Drinks"
    amount 100
    achieved_on nil

    trait :achieved do
      achieved_on { 30.days.ago }
    end

  end
end

