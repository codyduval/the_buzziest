require "minitest_helper"

describe BuzzPost do
  before do
    @buzz_post_29 = FactoryGirl.create(:buzz_post, post_date_time: 29.days.ago)
    @buzz_post_30 = FactoryGirl.create(:buzz_post, post_date_time: 30.days.ago)
    @buzz_post_31 = FactoryGirl.create(:buzz_post, post_date_time: 31.days.ago)
    @buzz_post_32 = FactoryGirl.create(:buzz_post, post_date_time: 32.days.ago)
  end
  
  describe "#new" do
    it "should create a buzz_post factory" do
      buzz_post = FactoryGirl.build(:buzz_post)
      
      buzz_post.wont_be_nil
    end
  end
 
  describe "#with_buzz_mentions" do  
    it "scope should get posts with buzz mentions" do
      buzz_post_with_mention = FactoryGirl.create(:buzz_post)
      buzz_mention = FactoryGirl.create(:buzz_mention, 
                                        :buzz_post => buzz_post_with_mention) 
      buzz_post_no_mentions = FactoryGirl.create(:buzz_post)

      with_buzz_mentions = BuzzPost.with_buzz_mentions

      with_buzz_mentions.must_include(buzz_post_with_mention)    
      with_buzz_mentions.wont_include(buzz_post_no_mentions)
    end
  end
  
  describe "#with_no_buzz_mentions" do
    it "gets all posts with no buzz mentions" do
      buzz_post_with_mention = FactoryGirl.create(:buzz_post)
      buzz_mention = FactoryGirl.create(:buzz_mention,
                                        :buzz_post => buzz_post_with_mention) 
      buzz_post_no_mentions = FactoryGirl.create(:buzz_post)

      with_no_buzz_mentions = BuzzPost.with_no_buzz_mentions

      with_no_buzz_mentions.wont_include(buzz_post_with_mention)    
      with_no_buzz_mentions.must_include(buzz_post_no_mentions)
    end
  end

  describe "#self.old_posts(age_in_days)" do
    it "gets posts older than age_in_days" do
      old_posts = BuzzPost.old_posts(30)

      old_posts.must_include(@buzz_post_31)
    end 
  end

  describe "#self.old_posts_no_mentions" do
    it "gets old posts with no mentions" do
      old_buzz_post_with_mention = FactoryGirl.create(:buzz_post,
                                                      post_date_time: 32.days.ago)
      buzz_mention = FactoryGirl.create(:buzz_mention,
                                        :buzz_post => old_buzz_post_with_mention) 
      buzz_post_no_mentions = FactoryGirl.create(:buzz_post, 
                                                 post_date_time: 32.days.ago)

      old_posts_no_mentions = BuzzPost.old_posts_no_mentions(30)

      old_posts_no_mentions.must_include(buzz_post_no_mentions)
      old_posts_no_mentions.wont_include(old_buzz_post_with_mention)
    end 
  end

  describe "#create_from_postmark" do
    let(:mitt) {Postmark::Mitt.new(read_fixture)}

    it "creates a new entry from postmark" do
      BuzzPost.create_from_postmark(mitt)
      id = "dd10d709-ca9f-46bf-8376-8dc489807a66"

      buzz_post = BuzzPost.where(:post_guid => id)
      buzz_post.first.post_guid.must_equal mitt.message_id
    end

    it "strips HTML from message body" do
      BuzzPost.create_from_postmark(mitt)

      buzz_post = BuzzPost.where(:buzz_source_id => 9999)
      buzz_post.first.post_content.wont_include "<html>"
    end
  end

  describe "#self.create_from_feed" do
    let(:source) {FactoryGirl.build(:feed_source)}
    let(:feed_client) {Fetch::RemoteBuzzPosts::FeedClient.new(source[:uri])}
    let(:empty_source) {FactoryGirl.build(:empty_feed_source)}
    let(:empty_feed_client) {Fetch::RemoteBuzzPosts::FeedClient.new(empty_source[:uri])}

    it "creates new BuzzPosts from feed" do
      feed_client.fetch_and_parse
      feed = feed_client.feed
      post_url = "http://ny.eater.com/archives/2013/05/cronut_wire.php"

      #Roll clock back so post fixture is accepted 
      Timecop.travel(2013, 5, 23) do
        BuzzPost.create_from_feed(feed, source)
      end 

      buzz_post = BuzzPost.where(:post_guid => 
        "tag:ny.eater.com,2013://4.520164")
      buzz_post.count.must_equal 1
      buzz_post.first.post_uri.must_equal post_url
    end

    it "does not create a duplicate BuzzPost" do
      feed_client.fetch_and_parse
      feed = feed_client.feed
      feed_dup = feed_client.feed
     
     #Roll clock back so post fixture is accepted 
      Timecop.travel(2013, 5, 23) do
        BuzzPost.create_from_feed(feed, source)
        BuzzPost.create_from_feed(feed_dup, source)
      end

      buzz_posts = BuzzPost.where(:post_guid => feed.entries.first.id)
      buzz_posts.count.must_equal 1
    end

    it "does not create BuzzPosts older than 25 days" do
      BuzzPost.destroy_all
      feed_client.fetch_and_parse
      feed = feed_client.feed

      Timecop.freeze(2013, 6, 23) do
        puts Date.today
        BuzzPost.create_from_feed(feed, source)
      end

      posts = BuzzPost.all
      posts.must_be_empty
    end

    it "does create BuzzPosts younger than 25 days" do
      BuzzPost.destroy_all
      feed_client.fetch_and_parse
      feed = feed_client.feed

      Timecop.freeze(2013, 6, 04) do
        puts Date.today
        BuzzPost.create_from_feed(feed, source)
      end

      posts = BuzzPost.all
      posts.wont_be_empty
    end

    it "doesn't crash if feed is bad" do
      BuzzPost.destroy_all
      empty_feed_client.fetch_and_parse
      feed = empty_feed_client.feed

      BuzzPost.create_from_feed(feed, source)

      posts = BuzzPost.all
      posts.must_be_empty
    end

    it "doesn't crash if a feed entry is blank" do
      BuzzPost.destroy_all
      feed_client.fetch_and_parse
      feed = feed_client.feed
      feed.entries << nil

      Timecop.freeze(2013, 6, 04) do
        puts Date.today
        BuzzPost.create_from_feed(feed, source)
      end

      posts = BuzzPost.all
      posts.wont_be_empty
    end

  end

  describe "#self.search_for_mentions(restaurants)" do
    it "should find all posts for multiple restaurants" do
      restaurant_one = FactoryGirl.create(:restaurant, name: "Gummo")
      restaurant_two = FactoryGirl.create(:restaurant, name: "Blammo")
      buzz_post = FactoryGirl.create(:buzz_post, post_title: "Gummo is a good place")
      buzz_post_two = FactoryGirl.create(:buzz_post,
                                         post_title: "I like Blammo")
      Sunspot.commit
      restaurants = [restaurant_one, restaurant_two]

      all_hits = BuzzPost.search_for_mentions(restaurants)
      restaurant_one_hits = all_hits.select do |hit|
        hit[:restaurant_id] == restaurant_one.id
      end

      restaurant_two_hits = all_hits.select do |hit|
        hit[:restaurant_id] == restaurant_two.id
      end

      restaurant_one_hits.first[:buzz_post_id].must_equal buzz_post.id
      restaurant_two_hits.first[:buzz_post_id].must_equal buzz_post_two.id
      all_hits.count.must_equal 2

    end

  end

  describe "#self.search_for_mention_of(restaurant)" do
    it "should find all posts that mention a restaurant" do
      restaurant = FactoryGirl.create(:restaurant, name: "Yummo")
      buzz_post = FactoryGirl.create(:buzz_post, post_title: "Yummo is a good place")
      Sunspot.commit

      hits = BuzzPost.search_for_mention_of(restaurant)

      hits.last[:buzz_post_id].must_equal buzz_post.id
      hits.count.must_equal 1
    end
  end
  

end
