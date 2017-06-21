FactoryGirl.define do
  factory :transaction do
    sender 
    receiver
    activity
    balance
    image
    amount 100
  end
end
