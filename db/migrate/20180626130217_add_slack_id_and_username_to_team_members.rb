class AddSlackIdAndUsernameToTeamMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :team_members, :slack_id, :string
    add_column :team_members, :slack_username, :string
  end
end
