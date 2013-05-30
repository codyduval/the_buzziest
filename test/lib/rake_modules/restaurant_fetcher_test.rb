require "minitest_helper"

describe RakeModules::RestaurantFetcher do
  before do
    source = FactoryGirl.create(:restaurant_list)
    source_two = FactoryGirl.create(:restaurant_list)
  end

  describe "#get_and_create_new_restaurants" do
    it "should create new Restaurant entries for found restaurants" do
      VCR.use_cassette('batch_restaurant_fetch') do
        RakeModules::RestaurantFetcher.get_and_create_new_restaurants(2)
      end

      Restaurant.count.must_equal 12
      Restaurant.last.name.must_equal "Wild"
      Restaurant.last.twitter_handle.must_equal "@mnwild"
    end
  end
end
