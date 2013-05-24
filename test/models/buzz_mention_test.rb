require "minitest_helper"

describe BuzzMention do

  describe "#new" do
    it "creates a BuzzMention factory" do
      buzz_mention = FactoryGirl.build(:buzz_mention)

      buzz_mention.wont_be_nil 
    end
  end

  describe "#not_ignored" do
    
    it "scope gets not ignored BuzzMentions" do
      mention_ignored = FactoryGirl.create(:buzz_mention, ignore: true)    
      mention_not_ignored = FactoryGirl.create(:buzz_mention, ignore: false)
      mention_not_ignored_two = FactoryGirl.create(:buzz_mention, ignore: false)
      buzz_mentions = BuzzMention.not_ignored

      buzz_mentions.wont_include(mention_ignored)
      buzz_mentions.must_include(mention_not_ignored)
      buzz_mentions.must_include(mention_not_ignored_two)
    end
  end

  describe "#ignored" do
    it "scope gets ignored BuzzMentions" do
      mention_ignored = FactoryGirl.create(:buzz_mention, ignore: true)    
      mention_not_ignored = FactoryGirl.create(:buzz_mention, ignore: false)
      mention_not_ignored_two = FactoryGirl.create(:buzz_mention, ignore: false)
      buzz_mentions = BuzzMention.ignored

      buzz_mentions.must_include(mention_ignored)
      buzz_mentions.wont_include(mention_not_ignored)
      buzz_mentions.wont_include(mention_not_ignored_two)
    end
  end

  describe "#tiny_decayed_buzz_score" do
    it "scope gets mentions with score less than 0.05" do
      mention_tiny_score = FactoryGirl.create(:buzz_mention,
                                              decayed_buzz_score: 0.04)
      mention_normal_score = FactoryGirl.create(:buzz_mention,
                                                decayed_buzz_score: 0.9)

      mentions = BuzzMention.tiny_decayed_buzz_score

      mentions.must_include(mention_tiny_score)
      mentions.wont_include(mention_normal_score)
    end
  end

  describe "#update_decay_buzz_score!" do
    it "updates mention with decayed buzz score" do
      mention = FactoryGirl.build(:buzz_mention, ignore: true)    
      mention.update_decayed_buzz_score!
      mention[:decayed_buzz_score].to_f.must_be :<, 2
    end
  end

end
