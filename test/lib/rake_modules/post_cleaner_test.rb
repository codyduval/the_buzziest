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

  describe "#self.old_buzz_post_ids" do
    it "gathers ids of posts older than 30 days with no mentions" do
      old_posts = RakeModules::PostCleaner.old_buzz_post_ids
      
      old_posts.must_include(@buzz_post_30.id)
      old_posts.wont_include(@buzz_post_32.id)
      old_posts.wont_include(@buzz_post_29.id)
    end

    it "returns ids of old posts" do
      old_posts = RakeModules::PostCleaner.old_buzz_post_ids  
      old_posts.first.must_be_instance_of Fixnum
    end
  end
  
  describe "#self.old_buzz_mention_ids" do
    it "gathers mentions that are ignored and 30 days old OR small score" do
      old_buzz_mentions = RakeModules::PostCleaner.old_buzz_mention_ids

      old_buzz_mentions.must_include(@buzz_mention_32_ignored.id)
      old_buzz_mentions.must_include(@buzz_mention_tiny.id)
      old_buzz_mentions.wont_include(@buzz_mention_32.id)
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
      buzz_mention_ids = []
      buzz_mention_ids.push(@buzz_mention_32.id)
      RakeModules::PostCleaner.destroy_old_buzz_mentions(buzz_mention_ids)

      BuzzMention.all.must_include @buzz_mention_32_ignored 
      BuzzMention.all.must_include @buzz_mention_tiny 
      BuzzMention.all.wont_include @buzz_mention_32
    end

    it "destroys multiple BuzzMentions" do
      buzz_mention_ids = []
      buzz_mention_ids.push(@buzz_mention_tiny.id, @buzz_mention_32.id)  
      RakeModules::PostCleaner.destroy_old_buzz_mentions(buzz_mention_ids)

      BuzzMention.all.wont_include @buzz_mention_32 
      BuzzMention.all.wont_include @buzz_mention_tiny
    end
  end

  describe "#self.destroy_old_buzz_posts" do
    it "destroys one BuzzPost" do
      buzz_post_ids= []
      buzz_post_ids.push(@buzz_post_29.id)
      RakeModules::PostCleaner.destroy_old_buzz_posts(buzz_post_ids)

      BuzzPost.all.must_include @buzz_post_32
      BuzzPost.all.must_include @buzz_post_30
      BuzzPost.all.wont_include @buzz_post_29
    end

    it "destroys multiple BuzzPosts" do
      buzz_post_ids = []
      buzz_post_ids.push(@buzz_post_32.id, @buzz_post_30.id)  
      RakeModules::PostCleaner.destroy_old_buzz_posts(buzz_post_ids)

      BuzzPost.all.wont_include @buzz_post_32
      BuzzPost.all.wont_include @buzz_post_30
    end
  end
end
