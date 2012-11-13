class CreateBuzzMentions < ActiveRecord::Migration
  def change
    create_table :buzz_mentions do |t|
      t.decimal :buzz_score
      t.integer :buzz_post_id
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
