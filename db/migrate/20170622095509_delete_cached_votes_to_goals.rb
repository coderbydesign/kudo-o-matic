class DeleteCachedVotesToGoals < ActiveRecord::Migration[5.0]
  def self.up
    remove_column :goals, :cached_votes_total, :integer, :default => 0
    remove_column :goals, :cached_votes_score, :integer, :default => 0
    remove_column :goals, :cached_votes_up, :integer, :default => 0
    remove_column :goals, :cached_votes_down, :integer, :default => 0
    remove_column :goals, :cached_weighted_score, :integer, :default => 0
    remove_column :goals, :cached_weighted_total, :integer, :default => 0
    remove_column :goals, :cached_weighted_average, :float, :default => 0.0

    # Uncomment this line to force caching of existing votes
    # Post.find_each(&:update_cached_votes)
  end

  def self.down
    remove_column :goals, :cached_votes_total
    remove_column :goals, :cached_votes_score
    remove_column :goals, :cached_votes_up
    remove_column :goals, :cached_votes_down
    remove_column :goals, :cached_weighted_score
    remove_column :goals, :cached_weighted_total
    remove_column :goals, :cached_weighted_average
  end
end
