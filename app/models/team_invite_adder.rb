# frozen_string_literal: true

class TeamInviteAdder
  include EmailRegex

  def self.create_from_email_list(emails, team)
    emails = emails.split(/\s*[,;]\s*/).map(&:strip)
    emails.each do |e|
      email = EmailRegex.extract_address(e)
      # unless User.where(email: email, team: team).exists?
      TeamInvite.create(email: email, team: team, sent_at: Time.now)
      # end
    end
  end
end
