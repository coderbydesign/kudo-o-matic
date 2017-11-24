class AddSlackKudosLeftOnCreationToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :slack_kudos_left_on_creation, :int
  end
end
