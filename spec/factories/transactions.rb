# == Schema Information
#
# Table name: transactions
#
#  id                           :integer          not null, primary key
#  sender_id                    :integer
#  receiver_id                  :integer
#  activity_id                  :integer
#  balance_id                   :integer
#  amount                       :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  image_file_name              :string
#  image_content_type           :string
#  image_file_size              :integer
#  image_updated_at             :datetime
#  slack_reaction_created_at    :string
#  slack_transaction_updated_at :string
#  slack_kudos_left_on_creation :integer
#  team_id                      :integer
#

FactoryBot.define do
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
