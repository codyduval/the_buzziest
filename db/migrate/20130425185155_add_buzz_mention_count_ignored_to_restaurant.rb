class AddBuzzMentionCountIgnoredToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :buzz_mention_count_ignored, :integer, :null => false, :default => 0
  end
end
