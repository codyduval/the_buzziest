class AddTotalCurrentBuzzToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :total_current_buzz, :decimal, :default => 0
  end
end
