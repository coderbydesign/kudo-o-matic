FactoryGirl.define do
  factory :user, aliases: [:sender, :receiver] do
    name "John"
    sequence(:email) { |n| "user-#{n}@test.host" }

    trait :admin do
      admin true
    end

    trait :api_token do
      api_token 'X0EfAbSlaeQkXm6gFmNtKA'
    end
  end
end
