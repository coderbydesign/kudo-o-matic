class AddSlackNameToTeamMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :team_members, :slack_name, :string
  end
end
