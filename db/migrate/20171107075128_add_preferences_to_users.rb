class AddPreferencesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :preferences, :json
  end
end
