require "minitest_helper"

describe BuzzMention do

  before do
    @buzz_mention_ignored = FactoryGirl.create(:buzz_mention, ignore: true)    
    @buzz_mention_not_ignored = FactoryGirl.create(:buzz_mention, ignore: false)
    @buzz_mention_not_ignored_two = FactoryGirl.create(:buzz_mention, ignore: false)
  end
 
  it "creates a BuzzMention factory" do
    buzz_mention = FactoryGirl.build(:buzz_mention)

    buzz_mention.wont_be_nil 
  end

  it "#not_ignored scope gets correct BuzzMentions" do
    buzz_mentions = BuzzMention.not_ignored

    buzz_mentions.wont_include(@buzz_mention_ignored)
    buzz_mentions.must_include(@buzz_mention_not_ignored)
    buzz_mentions.must_include(@buzz_mention_not_ignored_two)
  end

end
