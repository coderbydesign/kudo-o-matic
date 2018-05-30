class AddTeamToTransactionsAndBalances < ActiveRecord::Migration[5.0]
  def change
    add_reference :transactions, :team, index: true
    add_reference :balances, :team, index: true
  end
end
