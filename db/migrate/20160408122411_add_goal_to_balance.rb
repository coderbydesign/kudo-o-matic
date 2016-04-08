class AddGoalToBalance < ActiveRecord::Migration
  def change
    add_column :goals, :balance_id, :integer
  end
end
