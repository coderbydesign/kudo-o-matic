# frozen_string_literal: true
class Export < ActiveRecord::Base
  has_attached_file :zip
  validates_attachment_content_type :zip, 
                                    content_type: %w[application/zip application/x-zip application/x-zip-compressed]
  belongs_to :user
  before_destroy :delete_file

  def self.all_expired
    Export.where('created_at < ?', 1.week.ago)
  end

  private

  def delete_file
    zip.destroy
  end
end
