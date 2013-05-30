require "minitest_helper"

module Fetch
  module TwitterHandle

    describe Client do
        let(:restaurant) { FactoryGirl.build(:restaurant, name: "Bobby's Big Place!!") }

      describe "#initialize" do

        it "initializes a new client" do
          client_test = Fetch::TwitterHandle::Client.new(restaurant[:name])
          client_test.url.wont_be_nil
        end

        it "cleans out bad characters from restaurant name" do
          client_test = Fetch::TwitterHandle::Client.new(restaurant[:name])
          client_test.restaurant_name.must_equal "Bobbys%20Big%20Place"  
        end
      end

      describe "#fetch_and_parse" do

      end

    end

  end
end
  
