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
end

