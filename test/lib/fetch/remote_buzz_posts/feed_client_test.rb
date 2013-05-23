require "minitest_helper"

module Fetch
  module RemoteBuzzPosts

    describe FeedClient do
      let(:source) { FactoryGirl.create(:feed_source) } 

      describe "#initialize" do
        it "initializes a new client" do
          client_test = Fetch::RemoteBuzzPosts::FeedClient.new(source[:uri])
         
          client_test.url.must_equal source.uri
        end
      end

      describe "#fetch_and_parse" do
        it "fetches and parses HTML for source" do
          client_test = Fetch::RemoteBuzzPosts::FeedClient.new(source[:uri])

          client_test.fetch_and_parse

          client_test.feed.wont_equal 0
          entry = client_test.feed.entries.first
          entry.id.must_equal "tag:ny.eater.com,2013://4.520164"
        end
      end

    end
  end
end
  
