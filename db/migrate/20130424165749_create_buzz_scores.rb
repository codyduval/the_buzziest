class CreateBuzzScores < ActiveRecord::Migration
  def change
    create_table :buzz_scores do |t|
      t.integer :restaurant_id
      t.decimal :buzz_score, :default => 0

      t.timestamps
    end
  end
end
