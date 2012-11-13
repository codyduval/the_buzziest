class CreateBuzzSources < ActiveRecord::Migration
  def change
    create_table :buzz_sources do |t|
      t.string :name
      t.string :uri
      t.decimal :buzz_weight

      t.timestamps
    end
  end
end
