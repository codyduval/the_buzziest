require "minitest_helper"

describe RakeModules::PostCleaner do
  before do
    @restaurant = FactoryGirl.create(:restaurant)
    @buzz_post_29 = FactoryGirl.create(:buzz_post, post_date_time: 29.days.ago)
    @buzz_post_30 = FactoryGirl.create(:buzz_post, post_date_time: 30.days.ago)
    @buzz_post_32 = FactoryGirl.create(:buzz_post, post_date_time: 32.days.ago)
    Timecop.travel(32.days.ago) do
      @buzz_mention_32_ignored = FactoryGirl.create(:buzz_mention, ignore: true)
      @buzz_mention_32 = FactoryGirl.create(:buzz_mention, restaurant: @restaurant,
                                            buzz_post: @buzz_post_32)
    end
    @buzz_mention_tiny = FactoryGirl.create(:buzz_mention, decayed_buzz_score: 0.049)
  end

  describe "#self.old_buzz_posts" do
    it "gathers posts older than 30 days with no mentions" do
      old_posts = RakeModules::PostCleaner.old_buzz_posts_to_destroy
      
      old_posts.must_include(@buzz_post_30)
      old_posts.wont_include(@buzz_post_32)
      old_posts.wont_include(@buzz_post_29)
    end
  end
  
  describe "#self.old_buzz_mentions" do
    it "gathers mentions that are ignored and 30 days old OR small score" do
      old_buzz_mentions = 
        RakeModules::PostCleaner.old_buzz_mentions_to_destroy

      old_buzz_mentions.must_include(@buzz_mention_32_ignored)
      old_buzz_mentions.must_include(@buzz_mention_tiny)
      old_buzz_mentions.wont_include(@buzz_mention_32)
    end
  end

  describe "#self.update_counter_caches" do
    it "correctly updates the buzz mention counts on restaurant" do
      @restaurant.buzz_mention_count_ignored = 99
      @restaurant.save

      RakeModules::PostCleaner.update_counter_caches
      mentions = @restaurant.buzz_mentions.where(:ignore => false).count

      @restaurant.reload.buzz_mention_count_ignored.must_equal mentions
    end
  end

  describe "#self.destroy_old_buzz_mentions" do
    it "destroys one BuzzMention" do
      buzz_mentions = []
      buzz_mentions.push(@buzz_mention_32)
      RakeModules::PostCleaner.destroy_old_buzz_mentions(buzz_mentions)

      BuzzMention.all.must_include @buzz_mention_32_ignored 
      BuzzMention.all.must_include @buzz_mention_tiny 
      BuzzMention.all.wont_include @buzz_mention_32
    end

    it "destroys multiple BuzzMentions" do
      buzz_mentions = []
      buzz_mentions.push(@buzz_mention_tiny, @buzz_mention_32)  
      RakeModules::PostCleaner.destroy_old_buzz_mentions(buzz_mentions)

      BuzzMention.all.wont_include @buzz_mention_32 
      BuzzMention.all.wont_include @buzz_mention_tiny
    end
  end

  describe "#self.destroy_old_buzz_posts" do
    it "destroys one BuzzPost" do
      buzz_posts = []
      buzz_posts.push(@buzz_post_29)
      RakeModules::PostCleaner.destroy_old_buzz_posts(buzz_posts)

      BuzzPost.all.must_include @buzz_post_32
      BuzzPost.all.must_include @buzz_post_30
      BuzzPost.all.wont_include @buzz_post_29
    end

    it "destroys multiple BuzzPosts" do
      buzz_posts = []
      buzz_posts.push(@buzz_post_32, @buzz_post_30)  
      RakeModules::PostCleaner.destroy_old_buzz_posts(buzz_posts)

      BuzzPost.all.wont_include @buzz_post_32
      BuzzPost.all.wont_include @buzz_post_30
    end
  end
end
