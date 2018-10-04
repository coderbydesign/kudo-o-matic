# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  provider               :string
#  uid                    :string
#  avatar_url             :string
#  slack_name             :string
#  admin                  :boolean          default(FALSE)
#  api_token              :string
#  deactivated_at         :datetime
#  preferences            :json
#  slack_id               :string
#  slack_username         :string
#  restricted             :boolean          default(FALSE)
#  company_user           :boolean          default(FALSE)
#

FactoryBot.define do
  factory :user, aliases: [:sender, :receiver] do
    name "John"
    sequence(:email) {|n| "user-#{n}@test.host"}
    password "validpass"
    password_confirmation "validpass"
    confirmation_sent_at Time.now
    confirmed_at Time.now
    restricted false

    trait :admin do
      admin true
    end

    trait :api_token do
      api_token 'X0EfAbSlaeQkXm6gFmNtKA'
    end
  end
end
