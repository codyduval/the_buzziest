require "minitest_helper"
require "#{Rails.root}/lib/fetcher/restaurant/client.rb"

module Fetcher
  module Restaurant
    describe Client do
      before do
        @url = "http://www.tastingtable.com/dispatch/nyc/all/"
        @node = '//h5[@class="opened"]/following-sibling::div[@class="copy"]/h1'
        @city = "nyc"
      end
      describe "#initialize" do
        it "initializes a new client" do
          client = Client.new(@url, @node, @city)
          client.url.must_equal @url
        end

        it "starts with an empty @name_list" do
          client = Client.new(@url, @node, @city)
          client.name_list.must_be_empty 
        end
      end

      describe "#fetch" do
        it "gets remote data" do
          client = Client.new(@url, @node, @city)
          client.fetch
          client.name_list.first[:name].wont_be_nil
          client.name_list.first[:city].must_equal "nyc" 
        end
      end
    end
    describe NameFetcher do
      before do

      end      

      describe "#self.get_new_restaurants" do
        skip("To do")        
      end 

      describe "#self.add_restaurants" do
        skip("To do")
      end

    end 
  end
end
  
