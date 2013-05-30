require 'nokogiri'
require 'open-uri'

module RakeModules
  module BuzzPostFetcher

    def self.get_and_create_buzz_posts_feed(feed_sources)
      feed_sources.each do |feed_source|
        client = feed_client(feed_source)
        client.fetch_and_parse
        BuzzPost.create_from_feed(client.feed, feed_source) 
      end
    end

    def self.get_and_create_buzz_posts_twitter(twitter_sources)
      twitter_sources.each do |twitter_source|
        client = twitter_client(twitter_source)
        client.fetch_and_parse
        BuzzPost.create_from_twitter(client.timeline, twitter_source)
      end
    end

   private 

    def self.feed_client(source)
      @client = Fetch::RemoteBuzzPosts::FeedClient.new(source[:uri])
    end

    def self.twitter_client(source)
      @client = Fetch::RemoteBuzzPosts::TwitterClient.new(source[:uri])
    end

  end
end
