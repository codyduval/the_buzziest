class AddNullFalseToBuzzMentions < ActiveRecord::Migration
  def change
    change_column :buzz_mentions, :restaurant_id, :integer, :null => false
    change_column :buzz_mentions, :buzz_post_id, :integer, :null => false
    add_column :buzz_mentions, :highlight_text, :text
  end
end
