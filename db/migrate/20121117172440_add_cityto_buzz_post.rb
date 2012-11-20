class AddCitytoBuzzPost < ActiveRecord::Migration
  def change
    add_column :buzz_posts, :city_id, :integer
  end
end
