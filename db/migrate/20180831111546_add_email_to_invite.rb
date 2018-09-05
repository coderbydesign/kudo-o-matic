class AddEmailToInvite < ActiveRecord::Migration[5.0]
  def change
    add_column :team_invites, :email, :string
    add_index :team_invites, :email
  end
end
