require 'nokogiri'
require 'open-uri'

module Fetch
  module RemoteBuzzPosts 
    class TwitterClient

      attr_reader :twitter_handle, :timeline
      
      def initialize(twitter_handle)
        @twitter_handle = twitter_handle 
      end

      def fetch_and_parse
        @timeline = get(@twitter_handle)
      end

      private

      def get(twitter_handle)
        timeline = Twitter.user_timeline(twitter_handle) 
      end

    end
  end
end

