class AddSlugToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :slug, :string
  end
end
