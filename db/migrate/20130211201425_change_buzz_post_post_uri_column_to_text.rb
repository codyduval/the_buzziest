class ChangeBuzzPostPostUriColumnToText < ActiveRecord::Migration
  def change
    change_column :buzz_posts, :post_uri, :text
  end
end
