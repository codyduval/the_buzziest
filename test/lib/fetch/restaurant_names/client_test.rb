require "minitest_helper"

module Fetch
  module RestaurantNames

    describe Client do
      let(:source) { FactoryGirl.create(:restaurant_list) } 

      describe "#initialize" do
        it "initializes a new client" do
          client_test = Fetch::RestaurantNames::Client.new(source[:uri],
            source[:x_path_nodes],source[:city], 2)
         
          client_test.url.must_equal source.uri
          client_test.name_list.must_be_empty
          client_test.city.must_equal "nyc"
        end
      end

      describe "#fetch" do
        it "fetches and parses HTML for source" do
          client_test = Fetch::RestaurantNames::Client.new(source[:uri],
            source[:x_path_nodes],source[:city], 2)

          VCR.use_cassette('tt_restaurant_source') do
            client_test.fetch
          end

          client_test.name_list.first[:city].must_equal "nyc"
          client_test.name_list.last[:name].must_be_instance_of String
        end
      end
    end
  end
end
  
