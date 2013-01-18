class AddCounterCacheToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :buzz_mentions_count, :integer, :default => 0

    Restaurant.reset_column_information
    Restaurant.find_each do |r|
    Restaurant.reset_counters r.id, :buzz_mentions
  end
  end

  def self.down
    remove_column :restaurants, :buzz_mentions_count
  end
end

