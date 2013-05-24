require "minitest_helper"

describe BuzzMentionHighlight do
  describe "#new" do
    it "creates a BuzzMentionHighlight factory" do
      buzz_mention_highlight = FactoryGirl.create(:buzz_mention_highlight)

      buzz_mention_highlight.wont_be_nil 
    end
  end
end
