require "minitest_helper"

describe RakeModules::RestaurantFetcher do
  before do
    restaurant_list_sources = FactoryGirl.create_list(:restaurant_list, 5) 
    url = "kjdfkdj"
    node = "jdkfj"
    city = "nyc"
    client = Fetch::RestaurantNames::Client.new(url, node, city)
  end

  it "" do

    RakeModules::RestaurantFetcher.get_and_create_new_restaurants(@pages)

    Restaurant.all.last.must_equal new_restaurant    
  end

end
