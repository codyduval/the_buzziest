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

  describe "#fetch_and_update_twitter_handle!" do
    it "updates restaurant with best guess for twitter handle" do
      restaurant = FactoryGirl.create(:restaurant, name: "Happy Fun Time!!!")
      VCR.use_cassette('twitter_name_fetch') do
        restaurant.fetch_and_update_twitter_handle!
      end

      restaurant.twitter_handle.must_equal "@HappyFunTime"
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

  describe "#batch_create_from_remote" do
    let(:source) { FactoryGirl.create(:restaurant_list) } 

    it "adds new restaurant names and twitter handles to db" do
      remote_source_client = Fetch::RestaurantNames::Client.new(source) 
      VCR.use_cassette('tt_restaurant_source') do
        remote_source_client.fetch_and_parse
      end
      VCR.use_cassette('batch_twitter_handle_fetch') do
        Restaurant.batch_create_from_remote(remote_source_client)      
      end

      Restaurant.all.first.name.must_equal "ABC Cocina"
    end
  end
  
end

