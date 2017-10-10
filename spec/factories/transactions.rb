FactoryGirl.define do
  factory :transaction do
    sender
    receiver
    activity
    balance
    amount 100

    trait :image do
      image File.new(Rails.root + 'spec/fixtures/images/rails.png')
    end
  end
end
