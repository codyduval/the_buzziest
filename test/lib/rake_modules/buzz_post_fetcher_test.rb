require "minitest_helper"

describe RakeModules::BuzzPostFetcher do
  before do
  end

  describe "#get_and_create_buzz_posts_feed" do
    it "creates new buzz posts from all RSS feed stored in BuzzSources" do
      FactoryGirl.create(:feed_source)
      FactoryGirl.create(:feed_source)
      feed_sources = BuzzSource.all_feeds

      Timecop.travel(2013, 5, 23) do
        RakeModules::BuzzPostFetcher.get_and_create_buzz_posts_feed(feed_sources)
      end 

      BuzzPost.all.count.must_equal 50
      BuzzPost.first.post_guid.must_equal "tag:ny.eater.com,2013://4.520164"
    end

    it "outputs an error message if attempt to parse url returns 404" do
      bad_source = FactoryGirl.create(:feed_source,
                                      uri: "http://www.dkfjdkfjlsfjk.com")
      feed_sources = [bad_source] 

      get_and_create = Proc.new do
        RakeModules::BuzzPostFetcher.get_and_create_buzz_posts_feed(feed_sources)
      end

      get_and_create.must_output "No data for #{bad_source.uri}\n"
      
    end
  end

  describe "#get_and_create_buzz_posts_twitter" do
    it "creates new buzz posts from all twitter sources stored in BuzzSources" do
      FactoryGirl.create(:twitter_source)
      FactoryGirl.create(:twitter_source)
      twitter_sources = BuzzSource.all_twitter

      VCR.use_cassette('twitter_source', :record => :new_episodes) do
        RakeModules::BuzzPostFetcher.get_and_create_buzz_posts_twitter(twitter_sources)
      end

      BuzzPost.all.last.post_content.wont_be_nil 
      BuzzPost.all.last.post_content.length.must_be :<=, 140 
    end
  end
end
