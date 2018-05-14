class Export < ApplicationRecord
  belongs_to :user

  def zip_path
    Rails.root.join('public', 'exports', 'users', user.id.to_s, "export_#{uuid}.zip")
  end
end
