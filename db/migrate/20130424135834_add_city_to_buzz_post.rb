class AddCityToBuzzPost < ActiveRecord::Migration
  def change
    add_column :buzz_posts, :city, :string, :default => "nyc"
  end
end
