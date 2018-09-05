class RemoveUserIdFromTeamInvites < ActiveRecord::Migration[5.0]
  def change
    TeamInvite.find_each {|t| t.update(email: t.user.email)}
    remove_column :team_invites, :user_id, :fk
  end
end
