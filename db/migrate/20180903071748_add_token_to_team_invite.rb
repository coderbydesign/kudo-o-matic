class AddTokenToTeamInvite < ActiveRecord::Migration[5.0]
  def change
    add_column :team_invites, :token, :string
  end
end
