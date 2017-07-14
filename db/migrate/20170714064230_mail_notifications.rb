class MailNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :mail_notifications, :boolean
  end
end
