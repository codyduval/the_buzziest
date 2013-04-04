class CreateBuzzMentionHighlights < ActiveRecord::Migration
  def change
    create_table :buzz_mention_highlights do |t|
      t.integer :buzz_mention_id
      t.text :buzz_mention_highlight_text

      t.timestamps
    end
  end
end
