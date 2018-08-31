# frozen_string_literal: true

# == Schema Information
#
# Table name: exports
#
#  id               :integer          not null, primary key
#  uuid             :string
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  zip_file_name    :string
#  zip_content_type :string
#  zip_file_size    :integer
#  zip_updated_at   :datetime
#

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
