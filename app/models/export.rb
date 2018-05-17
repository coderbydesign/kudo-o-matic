class Export < ActiveRecord::Base
  belongs_to :user
  before_destroy :delete_file

  def self.all_expired
    Export.where('created_at < ?', 1.week.ago)
  end

  private

  def delete_file
    File.delete(zip) if File.exist?(zip)
  end
end
