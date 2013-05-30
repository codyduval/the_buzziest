require 'nokogiri'
require 'open-uri'

module Fetch
  module RemoteBuzzPosts 
    class FeedClient

      attr_reader :url, :feed
      
      def initialize(uri)
        @url = uri 
      end

      def fetch_and_parse
        @feed = get(@url)
      end

      private

      def get(url)
        feed = Feedzirra::Feed.fetch_and_parse(url)
      end

    end
  end
end

