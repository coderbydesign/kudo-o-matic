# frozen_string_literal: true

# == Schema Information
#
# Table name: teams
#
#  id                     :integer          not null, primary key
#  name                   :string
#  general_info           :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  logo_file_name         :string
#  logo_content_type      :string
#  logo_file_size         :integer
#  logo_updated_at        :datetime
#  slug                   :string
#  preferences            :json
#  slack_team_id          :string
#  slack_bot_access_token :string
#  channel_id             :string
#


FactoryBot.define do
  factory :team do
    name 'Kabisa'
    slug 'kabisa'
    general_info 'Some general info about the team.'
  end

end
