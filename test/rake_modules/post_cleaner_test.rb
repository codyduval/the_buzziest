require "minitest_helper"
require "#{Rails.root}/lib/rake_modules/post_cleaner.rb"

describe RakeModules::PostCleaner do
  before do
    @buzz_post_29 = FactoryGirl.create(:buzz_post, post_date_time: 29.days.ago)
    @buzz_post_30 = FactoryGirl.create(:buzz_post, post_date_time: 30.days.ago)
    @buzz_post_31 = FactoryGirl.create(:buzz_post, post_date_time: 31.days.ago)
    @buzz_post_32 = FactoryGirl.create(:buzz_post, post_date_time: 32.days.ago)
  end

  it "gathers ids of posts older than 30 days with no mentions" do
    old_posts = RakeModules::PostCleaner.old_buzz_posts
    
    old_posts.wont_be_empty
    old_posts.must_include(@buzz_post_31.id)
    old_posts.must_include(@buzz_post_30.id)
    old_posts.must_include(@buzz_post_32.id)
    old_posts.wont_include(@buzz_post_29.id)
  end

  it "does not decrease score for ignored BuzzMentions" do
  end

end
