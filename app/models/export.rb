class Export < ApplicationRecord
  belongs_to :user

  def self.all_expired
    Export.where('created_at < ?', 1.week.ago)
  end
end
