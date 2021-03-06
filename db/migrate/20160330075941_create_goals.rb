class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :name, limit: 32
      t.integer :amount
      t.date :achieved_on, default: nil

      t.timestamps null: false
    end
  end
end
