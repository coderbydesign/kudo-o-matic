class RemoveUserIdFromTeamInvites < ActiveRecord::Migration[5.0]
  def change
    TeamInvite.find_each {|t| t.update(email: User.find(t.user_id).email)}
    remove_column :team_invites, :user_id, :fk
  end
end
