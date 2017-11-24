class AddSlackTransactionUpdatedAtToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :slack_transaction_updated_at, :string
  end
end
