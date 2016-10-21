FactoryGirl.define do
  factory :balance do
    name "My Balance"
    amount 100

    trait :current do
      current true
    end
  end
end
