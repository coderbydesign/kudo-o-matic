class RemoveAmountFromBalance < ActiveRecord::Migration[5.0]
  def change
    remove_column :balances, :amount
  end
end
