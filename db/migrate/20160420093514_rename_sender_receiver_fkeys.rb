class RenameSenderReceiverFkeys < ActiveRecord::Migration
  def change
    rename_column :transactions, :from_id, :sender_id
    rename_column :transactions, :to_id, :receiver_id
  end
end
