class RemoveTokenFromTeamInvite < ActiveRecord::Migration[5.0]
  def change
    remove_column :team_invites, :token, :string
  end
end
