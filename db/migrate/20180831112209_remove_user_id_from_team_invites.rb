class RemoveUserIdFromTeamInvites < ActiveRecord::Migration[5.0]
  def change
    remove_column :team_invites, :user_id, :fk
  end
end
