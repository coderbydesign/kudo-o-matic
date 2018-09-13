class AddTeamToGuideline < ActiveRecord::Migration[5.0]
  def change
    add_reference :guidelines, :teams, foreign_key: true
  end
end
