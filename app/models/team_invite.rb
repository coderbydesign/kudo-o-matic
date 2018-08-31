# frozen_string_literal: true

# == Schema Information
#
# Table name: team_invites
#
#  id          :integer          not null, primary key
#  team_id     :integer
#  user_id     :integer
#  sent_at     :datetime
#  accepted_at :datetime
#  declined_at :datetime
#


class TeamInvite < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  def complete?
    accepted_at || declined_at
  end

  def accept
    TeamInvite.transaction do
      update_attribute(:accepted_at, Time.now)
    end
    TeamMember.create(team: team, user: user, admin: false)
  end

  def decline
    TeamInvite.transaction do
      update_attribute(:declined_at, Time.now)
    end
  end

  def self.open
    where(accepted_at: nil).where(declined_at: nil)
  end
end
