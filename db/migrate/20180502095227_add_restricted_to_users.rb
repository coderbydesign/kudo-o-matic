# frozen_string_literal: true
class AddRestrictedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :restricted, :boolean, default: false
  end
end
