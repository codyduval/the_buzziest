class RemoveBuzzSourceName < ActiveRecord::Migration
  def up
    remove_column :buzz_posts, :buzz_source_name
  end

  def down
    add_column :buzz_posts, :buzz_source_name
  end
end
