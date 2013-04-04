class BuzzMentionHighlight < ActiveRecord::Base
  attr_accessible :buzz_mention_highlight_text, :buzz_mention_id

  belongs_to :buzz_mention
end
