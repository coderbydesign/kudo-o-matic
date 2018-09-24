class CreateGuidelines < ActiveRecord::Migration[5.0]
  def change
    create_table :guidelines do |t|
      t.string :name
      t.integer :kudos

      t.timestamps
      t.references :team, index: true
    end
  end
end
