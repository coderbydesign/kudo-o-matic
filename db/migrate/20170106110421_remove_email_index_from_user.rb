class RemoveEmailIndexFromUser < ActiveRecord::Migration[5.0]
  def change
    begin
      remove_index :users, :email
    rescue
      puts 'skipped migration'
    end
  end
end
