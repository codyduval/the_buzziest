require "minitest_helper"

describe BuzzScore do
  describe "#new" do
    it "should create a BuzzScore factory" do
      buzz_score = FactoryGirl.build(:buzz_score)
      
      buzz_score.wont_be_nil
    end
  end

  
  describe "#create_score_entry" do
    it "creates a new entry in BuzzScore table" do
      restaurant = FactoryGirl.create(:restaurant, name: Faker::Company.name) 
      buzz_mention = FactoryGirl.create(:buzz_mention, :restaurant => restaurant,
                                        decayed_buzz_score: 5)

      buzz_score = BuzzScore.create_score_entry(restaurant)

      buzz_score.buzz_score.must_equal(5)
    end
  end

  describe "#update_restaurant_cache_value" do
    it "calls updates restaurant record after_create" do
      buzz_score = FactoryGirl.create(:buzz_score, buzz_score: 99)

      buzz_score.restaurant.total_current_buzz.must_equal(99)
    end
  end
end
