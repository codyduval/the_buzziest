class AddCounterCacheToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :buzz_mentions_count, :integer, :default => 0
    Restaurant.find_each do |restaurant|
      restaurant.update_attribute(:buzz_mentions_count, restaurant.buzz_mentions.length)
      restaurant.save
    end
  end

  def self.down
    remove_column :restaurants, :buzz_mentions_count
  end
end

