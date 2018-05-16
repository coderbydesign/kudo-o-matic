class Export < ActiveRecord::Base
  belongs_to :user

  def self.all_expired
    Export.where('created_at < ?', 1.week.ago)
  end
end
