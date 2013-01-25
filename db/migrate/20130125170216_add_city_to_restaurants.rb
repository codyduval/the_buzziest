class AddCityToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :city, :string, :default => "nyc"
  end
end
