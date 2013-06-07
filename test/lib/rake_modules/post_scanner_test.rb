require "minitest_helper"

describe RakeModules::PostScanner do
  before do
  end

  describe "#get_and_create_new_restaurants" do
    it "should create new Restaurant entries for found restaurants" do
      restaurant_one = FactoryGirl.create(:restaurant, name: "Yum")
      restaurant_two = FactoryGirl.create(:restaurant, name: "Roboto")
      post_one = FactoryGirl.create(:buzz_post, post_title: "Yum is a good place")
      post_two = FactoryGirl.create(:buzz_post, post_title: "Roboto is the bomboto")
      Sunspot.commit

      restaurants = Restaurant.all
      RakeModules::PostScanner.search_for_and_create_buzz_mentions(restaurants)

      mention = BuzzMention.where(:restaurant_id => restaurant_one.id).first
      mention_two = BuzzMention.where(:restaurant_id => restaurant_two.id).first

      mention.buzz_post_id.must_equal post_one.id  
      mention_two.buzz_post_id.must_equal post_two.id  
    end
  end
end
