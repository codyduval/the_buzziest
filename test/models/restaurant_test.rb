require "minitest_helper"

describe Restaurant do
  describe "#new" do
    it "creates a Restaurant factory" do
      restaurant = FactoryGirl.build(:restaurant)

      restaurant.wont_be_nil 
    end

    it "does not allow duplicate entries for name" do 
      name = Faker::Company.name
      restaurant = FactoryGirl.create(:restaurant, name: name)
      
      second_restaurant = FactoryGirl.build(:restaurant, 
                                            name: name).valid?.must_equal(false)
    end
  end

  describe "#with_buzz" do
    it "scope does NOT collect Restaurants with no buzz mentions" do
      restaurant_no_buzz_mentions = FactoryGirl.create(:restaurant)
      restaurants = Restaurant.with_buzz

      restaurants.wont_include(restaurant_no_buzz_mentions)
    end

    it "scope does collect Restaurants with buzz mentions" do
      buzz_mention_not_ignored = FactoryGirl.create(:buzz_mention, ignore: false)
      restaurant_with_buzz = buzz_mention_not_ignored.restaurant 
      restaurants = Restaurant.with_buzz

      restaurants.must_include(restaurant_with_buzz)
    end
  end

  describe "#total_score" do
    it "calculates score for all related buzz mentions" do
      restaurant = FactoryGirl.create(:restaurant)
      mention = FactoryGirl.create(:buzz_mention, :restaurant => restaurant,
                                   decayed_buzz_score: 2)
      mention_2 = FactoryGirl.create(:buzz_mention, :restaurant => restaurant,
                                     decayed_buzz_score: 3)
      mention_ignored = FactoryGirl.create(:buzz_mention, :restaurant => restaurant,
                                           decayed_buzz_score: 4, :ignore => true)

      restaurant.total_score.must_equal(5)
    end
  end
  
end

