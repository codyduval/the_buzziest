require "minitest_helper"

describe Restaurant do
  it "creates a Restaurant factory" do
    restaurant = FactoryGirl.build(:restaurant)

    restaurant.wont_be_nil 
  end

  it "does not allow duplicate entries for name" do 
    name = Faker::Company.name
    restaurant = FactoryGirl.create(:restaurant, name: name)
    
    second_restaurant = FactoryGirl.build(:restaurant, name: name).valid?.must_equal(false)
  end

  it "#with_buzz scope does NOT collect Restaurants with no buzz mentions" do
    restaurant_no_buzz_mentions = FactoryGirl.create(:restaurant)
    restaurants = Restaurant.with_buzz

    restaurants.wont_include(restaurant_no_buzz_mentions)
  end

  it "#with_buzz scope does collect Restaurants with buzz mentions" do
    buzz_mention_not_ignored = FactoryGirl.create(:buzz_mention, ignore: false)
    restaurant_with_buzz = buzz_mention_not_ignored.restaurant 
    restaurants = Restaurant.with_buzz

    restaurants.must_include(restaurant_with_buzz)
  end
  
  it "#total_score calculates score for all related buzz mentions" do
    restaurant = FactoryGirl.create(:restaurant, name: Faker::Company.name)
    a_buzz_mention = restaurant.buzz_mentions.create(:decayed_buzz_score => 2)
    another_buzz_mention = restaurant.buzz_mentions.create(:buzz_score => 3, :decayed_buzz_score => 3)
    ignored_buzz_mention = restaurant.buzz_mentions.create(:buzz_score => 5, :decayed_buzz_score => 5, :ignore => true)

    restaurant.total_score.must_equal(5)
  end
  
end

