class RemoveMailNotificationsFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :mail_notifications, :boolean
  end
end
