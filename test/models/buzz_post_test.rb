require "minitest_helper"

describe BuzzPost do
  before do
    @buzz_post_29 = FactoryGirl.create(:buzz_post, post_date_time: 29.days.ago)
    @buzz_post_30 = FactoryGirl.create(:buzz_post, post_date_time: 30.days.ago)
    @buzz_post_31 = FactoryGirl.create(:buzz_post, post_date_time: 31.days.ago)
    @buzz_post_32 = FactoryGirl.create(:buzz_post, post_date_time: 32.days.ago)
  end
  
  it "should create a buzz_post factory" do
    buzz_post = FactoryGirl.build(:buzz_post)
    
    buzz_post.wont_be_nil
  end
  
  it "#with_buzz_mentions scope should get posts with buzz mentions" do
    buzz_post_with_mention = FactoryGirl.create(:buzz_post)
    buzz_mention = FactoryGirl.create(:buzz_mention, :buzz_post => buzz_post_with_mention) 
    buzz_post_no_mentions = FactoryGirl.create(:buzz_post)

    with_buzz_mentions = BuzzPost.with_buzz_mentions

    with_buzz_mentions.must_include(buzz_post_with_mention)    
    with_buzz_mentions.wont_include(buzz_post_no_mentions)
  end
  
  it "#with_no_buzz_mentions scope should get no posts with buzz mentions" do
    buzz_post_with_mention = FactoryGirl.create(:buzz_post)
    buzz_mention = FactoryGirl.create(:buzz_mention, :buzz_post => buzz_post_with_mention) 
    buzz_post_no_mentions = FactoryGirl.create(:buzz_post)

    with_buzz_mentions = BuzzPost.with_no_buzz_mentions

    with_buzz_mentions.wont_include(buzz_post_with_mention)    
    with_buzz_mentions.must_include(buzz_post_no_mentions)
  end

  it "#self.old_posts(age_in_days) should get posts older than age_in_days" do
    old_posts = BuzzPost.old_posts(30)

    old_posts.must_include(@buzz_post_31)
  end 

  it "#self.old_posts_no_mentions(age_in_days) should get appropraite posts" do
    old_buzz_post_with_mention = FactoryGirl.create(:buzz_post, post_date_time: 32.days.ago)
    buzz_mention = FactoryGirl.create(:buzz_mention, :buzz_post => old_buzz_post_with_mention) 
    buzz_post_no_mentions = FactoryGirl.create(:buzz_post, post_date_time: 32.days.ago)

    old_posts_no_mentions = BuzzPost.old_posts_no_mentions(30)

    old_posts_no_mentions.must_include(buzz_post_no_mentions)
    old_posts_no_mentions.wont_include(old_buzz_post_with_mention)
  end 

  it "#create_from_postmark(mitt) a new entry" do
    skip("TO DO")
  end

  describe "#self.create_from_feed" do
    let(:source) {FactoryGirl.build(:feed_source)}
    let(:feed_client) {Fetch::RemoteBuzzPosts::FeedClient.new(source[:uri])}

    it "creates new BuzzPosts from feed" do
      feed_client.fetch_and_parse
      feed = feed_client.feed

      BuzzPost.create_from_feed(feed, source)
      
      buzz_post = BuzzPost.where(:post_guid => "tag:ny.eater.com,2013://4.520164")
      buzz_post.count.must_equal 1
      buzz_post.first.post_uri.must_equal "http://ny.eater.com/archives/2013/05/cronut_wire.php"

    end
  end

end
