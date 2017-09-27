FactoryGirl.define do
  factory :user, aliases: [:sender, :receiver] do
    name "John"
    sequence(:email) { |n| "user-#{n}@test.host" }

    trait :admin do
      admin true
    end
  end
end
