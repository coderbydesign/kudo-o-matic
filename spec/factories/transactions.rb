FactoryGirl.define do
  factory :transaction do
    sender
    receiver
    activity
    balance
    image File.new(Rails.root + 'spec/fixtures/images/rails.png')
    amount 100
  end
end
