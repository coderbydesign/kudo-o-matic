# frozen_string_literal: true

class TeamInvite < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  def accept
    update_attribute(:accepted_at, Time.now)
    TeamMember.create(team: team, user: user, admin: false)
  end

  def decline
    update_attribute(:declined_at, Time.now)
  end
end
