class AddCityIdToBuzzSources < ActiveRecord::Migration
  def change
        add_column :buzz_sources, :city_id, :integer
  end
end
