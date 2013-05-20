class ChangeBuzzMentionBuzzScoreDefaultValue < ActiveRecord::Migration
  def change
    change_column :buzz_mentions, :buzz_score, :decimal, :default => 0.0    
  end
end
