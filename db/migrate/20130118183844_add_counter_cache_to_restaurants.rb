class AddCounterCacheToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :buzz_mentions_count, :integer, :default => 0

  end

  def self.down
    remove_column :restaurants, :buzz_mentions_count
  end
end

