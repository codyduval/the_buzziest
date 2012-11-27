class AddTwiiterHandleToRestaurants < ActiveRecord::Migration
  def change
        add_column :restaurants, :twitter_handle, :string
        remove_column :restaurants, :rank_previous
        remove_column :restaurants, :rank 
  end
end
