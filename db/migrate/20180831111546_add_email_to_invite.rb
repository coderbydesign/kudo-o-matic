class AddEmailToInvite < ActiveRecord::Migration[5.0]
  def change
    add_column :team_invites, :email, :string
  end
end
