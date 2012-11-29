class RemoveCityIdFromBuzzPost < ActiveRecord::Migration
  def change
    remove_column :buzz_posts, :city_id
  end
end
