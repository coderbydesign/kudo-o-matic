# frozen_string_literal: true

class CreateTeamInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :team_invites do |t|
      t.references :team, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamp :sent_at, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :accepted_at, null: true
      t.timestamp :declined_at, null: true
    end
  end
end
