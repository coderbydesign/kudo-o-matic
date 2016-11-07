class ChangeActivityNameColumnType < ActiveRecord::Migration[5.0]
  def change
    change_column :activities, :name, :text
  end
end
