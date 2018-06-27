class AddSlackTeamIdToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :slack_team_id, :string
  end
end
