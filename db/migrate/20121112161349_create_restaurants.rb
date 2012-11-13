class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.integer :rank
      t.integer :rank_previous
      t.string :style
      t.integer :weeks_on_list
      t.string :neighborhood
      t.string :reserve
      t.text :description

      t.timestamps
    end
  end
end
