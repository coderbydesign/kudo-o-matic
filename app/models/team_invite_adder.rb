# frozen_string_literal: true

class TeamInviteAdder
  def self.create_from_email_list(emails, team)
    emails = emails.gsub(/\s+/, '').split(',')
    users = User.where(email: emails)
    users.each do |user|
      unless user.member_of?(team) || user.invited_to?(team)
        TeamInvite.create(user: user, team: team)
      end
    end
  end
end
