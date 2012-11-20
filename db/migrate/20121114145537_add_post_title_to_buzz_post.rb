class AddPostTitleToBuzzPost < ActiveRecord::Migration
  def change
    add_column :buzz_posts, :post_title, :string
  end
end
