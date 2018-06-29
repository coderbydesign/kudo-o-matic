# frozen_string_literal: true

class TeamInviteForm
  include EmailRegex
  include ActiveModel::Model

  attr_accessor :emails

  validates :emails, presence: true
  validate :validate_emails

  private

  def validate_emails
    email_list = emails.split(/\s*[,;]\s*/).map(&:strip)
    email_list.each do |e|
      unless e.match(EmailRegex.valid_regex)
        errors.add(:emails, 'should only include valid emailadresses')
      end
    end
  end
end
