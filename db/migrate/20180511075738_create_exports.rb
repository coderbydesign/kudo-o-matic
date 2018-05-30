# frozen_string_literal: true
class CreateExports < ActiveRecord::Migration[5.0]
  def change
    create_table :exports do |t|
      t.string :uuid
      t.references :user, foreign_key: true
      t.string :zip, null: true

      t.timestamps
    end
  end
end
