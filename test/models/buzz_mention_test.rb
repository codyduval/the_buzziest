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

  it "#not_ignored scope gets not ignored BuzzMentions" do
    buzz_mentions = BuzzMention.not_ignored

    buzz_mentions.wont_include(@buzz_mention_ignored)
    buzz_mentions.must_include(@buzz_mention_not_ignored)
    buzz_mentions.must_include(@buzz_mention_not_ignored_two)
  end

  it "#ignored scope gets ignored BuzzMentions" do
    buzz_mentions = BuzzMention.ignored

    buzz_mentions.must_include(@buzz_mention_ignored)
    buzz_mentions.wont_include(@buzz_mention_not_ignored)
    buzz_mentions.wont_include(@buzz_mention_not_ignored_two)
  end

  it "#tiny_decayed_buzz_score scope gets BuzzMentions with score less than 0.05" do
    buzz_mention_tiny_score = FactoryGirl.create(:buzz_mention, decayed_buzz_score: 0.04)
    buzz_mention_normal_score = FactoryGirl.create(:buzz_mention, decayed_buzz_score: 0.9)

    buzz_mentions = BuzzMention.tiny_decayed_buzz_score

    buzz_mentions.must_include(buzz_mention_tiny_score)
    buzz_mentions.wont_include(buzz_mention_normal_score)
  end

  it "#update_decay_buzz_score! correctly" do
    @buzz_mention_not_ignored.update_decayed_buzz_score!
    @buzz_mention_not_ignored[:decayed_buzz_score].to_f.must_be :<, 2
  end

end
