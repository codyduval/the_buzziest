require "minitest_helper"

describe BuzzSource do
  describe "#new" do
    it "creates a BuzzSource factory" do
      buzz_source = FactoryGirl.build(:buzz_source)
      
      buzz_source.wont_be_nil
    end
  end

  describe "#all_twitter scope" do
    it "Returns all twitter sources" do
      twitter_source = FactoryGirl.create(:twitter_source)
      feed_source = FactoryGirl.create(:feed_source)

      BuzzSource.all_twitter.must_include twitter_source
      BuzzSource.all_twitter.wont_include feed_source
    end
  end

  describe "#all_feeds scope" do
    it "Returns all feed sources" do
      twitter_source = FactoryGirl.create(:twitter_source)
      feed_source = FactoryGirl.create(:feed_source)

      BuzzSource.all_feeds.must_include feed_source
      BuzzSource.all_feeds.wont_include twitter_source
    end
  end
end
