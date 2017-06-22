FactoryGirl.define do
  factory :transaction do
    sender 
    receiver
    activity
    balance

    amount 100
  end
end
