class AddExactMatchToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :exact_match, :boolean
    add_column :restaurants, :skip_scan, :boolean
  end
end
