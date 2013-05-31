require 'nokogiri'
require 'open-uri'

module RakeModules
  module BuzzPostFetcher

    def self.get_and_create_buzz_posts_feed(feed_sources)
      progress_bar = ProgressBar.create(:format =>"%C %t %e %b", 
                                        :title => "feeds to fetch...", 
                                        :total => feed_sources.count)
      feed_sources.each do |feed_source|
        client = feed_client(feed_source)
        client.fetch_and_parse
        BuzzPost.create_from_feed(client.feed, feed_source) 
        progress_bar.increment
      end
    end

    def self.get_and_create_buzz_posts_twitter(twitter_sources)
      progress_bar = ProgressBar.create(:format =>"%C %t %e %b", 
                                        :title => "twitter feeds to fetch...", 
                                        :total => twitter_sources.count)
      twitter_sources.each do |twitter_source|
        client = twitter_client(twitter_source)
        client.fetch_and_parse
        BuzzPost.create_from_twitter(client.timeline, twitter_source)
        progress_bar.increment
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
