# == Schema Information
#
# Table name: team_members
#
#  id             :integer          not null, primary key
#  team_id        :integer
#  user_id        :integer
#  admin          :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  slack_id       :string
#  slack_username :string
#  slack_name     :string
#

class TeamMember < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
end
