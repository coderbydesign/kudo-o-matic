class AddPreferencesToTeam < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :preferences, :json
  end
end
