class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.text :general_info

      t.timestamps
    end
    add_attachment :teams, :logo
  end
end
