class AddCityToBuzzSources < ActiveRecord::Migration
  def change
    add_column :buzz_sources, :city, :string, :default => "nyc"
  end
end
