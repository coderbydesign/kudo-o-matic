class AddSlackReactionCreatedAtToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :slack_reaction_created_at, :string
  end
end
