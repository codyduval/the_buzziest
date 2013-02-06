class AddWeightedBuzzScoreToBuzzMention < ActiveRecord::Migration
  def change
    add_column :buzz_mentions, :decayed_buzz_score, :decimal
  end
end
