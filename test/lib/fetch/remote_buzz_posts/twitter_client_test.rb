require "minitest_helper"

module Fetch
  module RemoteBuzzPosts

    describe TwitterClient do
      let(:source) { FactoryGirl.create(:twitter_source) } 

      describe "#initialize" do
        it "initializes a new client" do
          client_test = Fetch::RemoteBuzzPosts::TwitterClient.new(source[:uri])
         
          client_test.twitter_handle.must_equal source.uri
        end
      end

      describe "#fetch_and_parse" do
        it "fetches and parses HTML for source" do
          client_test = Fetch::RemoteBuzzPosts::TwitterClient.new(
                                                    source[:uri])

          VCR.use_cassette('twitter_source') do
            client_test.fetch_and_parse
          end

         client_test.timeline.wont_be_empty
        end

        it "must contain valid data" do
          client_test = Fetch::RemoteBuzzPosts::TwitterClient.new(
                                                    source[:uri])

          VCR.use_cassette('twitter_source') do
            client_test.fetch_and_parse
          end

          tweet = client_test.timeline.first
          tweet.id.must_be_instance_of Fixnum
          tweet.text.length.must_be :<=, 140
        end
      end

    end
  end
end
  
