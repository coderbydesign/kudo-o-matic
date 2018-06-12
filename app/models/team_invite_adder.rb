# frozen_string_literal: true

class TeamInviteAdder
  include EmailRegex

  def self.create_from_email_list(emails, team)
    formatted_emails = []
    emails = emails.split(/\s*[,;]\s*/).map(&:strip)
    emails.each do |e|
      formatted_emails.append(EmailRegex.extract_address(e))
    end
    users = User.where(email: formatted_emails)
    users.each do |user|
      unless user.member_of?(team) || user.invited_to?(team)
        TeamInvite.create(user: user, team: team)
      end
    end
  end
end
