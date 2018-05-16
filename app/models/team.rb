# frozen_string_literal: true

class Team < ActiveRecord::Base
  has_attached_file :logo, styles: {thumb: '600x600'}
  validates_attachment :logo, content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }
  validates_with AttachmentSizeValidator, attributes: :logo, less_than: 10.megabytes
  process_in_background :logo

  def add_member(user, admin=false)
    TeamMember.create(user: user, team: self, admin: admin)
  end

  def remove_member(user)
    TeamMember.find_by_user_id_and_team_id(user.id, id).delete
  end

  def member?(user)
    TeamMember.find_by_user_id_and_team_id(user.id, id).present?
  end
end
