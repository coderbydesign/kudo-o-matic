class RenameActivityAmountToSuggestedAmount < ActiveRecord::Migration
  def change
    rename_column :activities, :amount, :suggested_amount
  end
end
