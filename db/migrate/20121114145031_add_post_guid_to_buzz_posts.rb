class AddPostGuidToBuzzPosts < ActiveRecord::Migration
  def change
    add_column :buzz_posts, :post_guid, :string
  end
end
