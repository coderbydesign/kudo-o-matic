# frozen_string_literal: true

class TeamInviteSubmission
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  include ActiveModel::Model

  attr_accessor :emails

  validates :emails, presence: true
  validate :validate_emails

  private

  def validate_emails
    email_list = emails.gsub(/\s+/, '').split(',')
    email_list.each do |e|
      unless e.match(VALID_EMAIL_REGEX)
        errors.add(:emails, 'should only include valid emailadresses')
      end
    end
  end
end
