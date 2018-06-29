class AddChannelIdToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :channel_id, :string
  end
end
