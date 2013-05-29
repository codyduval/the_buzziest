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
        timeline = client.timeline
        BuzzPost.create_from_twitter(timeline, twitter_source)
      end
    end

   private 

    def self.feed_client(source)
      @client = Fetch::RemoteBuzzPosts::FeedClient.new(source[:uri])
    end

    def self.twitter_client(source)
      @client = Fetch::RemoteBuzzPosts::TwitterClient.new(source[:uri])
    end

    def self.get_feed_buzz_sources(buzz_source_types)
      buzz_sources_array = Array.new
      buzz_source_types.each do |buzz_source_type|
        buzz_source = BuzzSource.where(:buzz_source_type  => buzz_source_type)
        buzz_sources_array.push(buzz_source)
      end
      return buzz_sources_array
    end

  end
end
