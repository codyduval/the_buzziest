class CreateBuzzPosts < ActiveRecord::Migration
  def change
    create_table :buzz_posts do |t|
      t.string :buzz_source_name
      t.datetime :post_date_time
      t.string :post_uri
      t.text :post_content
      t.boolean :scanned_flag
      t.decimal :post_weight
      t.integer :buzz_source_id

      t.timestamps
    end
  end
end
