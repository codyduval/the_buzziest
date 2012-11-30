class AddCityIdToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :city_id, :integer
  end
end
