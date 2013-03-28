class AddIgnoreToBuzzMentions < ActiveRecord::Migration
  def change
    add_column :buzz_mentions, :ignore, :boolean, :default => false
  end
end
