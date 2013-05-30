require "minitest_helper"

module Fetch
  module TwitterHandle

    describe Client do
        let(:restaurant) { FactoryGirl.build(:restaurant, 
                                             name: "Bobby's Big Place!!") }

      describe "#initialize" do
        it "initializes a new client with correct url" do
          client_test = Fetch::TwitterHandle::Client.new(restaurant[:name])

          client_test.url.must_equal\
              "https://twitter.com/search/users?q=Bobbys%20Big%20Place" 
        end
      end

      describe "#fetch_and_parse" do
        it "returns a twitter handle from fetched HTML" do
          client_test = Fetch::TwitterHandle::Client.new(restaurant[:name])
          VCR.use_cassette('twitter_handle_fetch') do
            client_test.fetch_and_parse
          end

          client_test.twitter_handle.must_equal "@bflay"
        end
      end

    end

  end
end
  
