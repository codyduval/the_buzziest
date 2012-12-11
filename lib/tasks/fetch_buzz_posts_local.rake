desc "Fetch posts that contain restaurant buzz"
task :fetch_buzz_posts_local, [:city, :source_type] => :environment do |t, args|
  args.with_defaults(:city => "nyc", :source_type => "all")

  include ActionView::Helpers::SanitizeHelper
  require 'benchmark'


time_elapsed = Benchmark.realtime do

def self.get_buzz_source_types(args)
  unless args.source_type == 'all'
    buzz_source_types = BuzzSourceType.where(:source_type=> args.source_type)
  else
    buzz_source_types = BuzzSourceType.where("source_type = 'feed' OR source_type = 'twitter'")
  end
end

def self.get_buzz_sources(buzz_source_types)
  buzz_sources = Array.new
  buzz_source_types.each do |buzz_source_type|
    buzz_source = BuzzSource.where(:buzz_source_type_id => buzz_source_type.id)
    buzz_sources.push(buzz_source)
  end
  buzz_sources
end

def get_posts_from_source(buzz_sources_array)
  buzz_sources_array.each do |buzz_sources|
    buzz_sources.each do |buzz_source|
      if buzz_source.buzz_source_type.source_type == 'feed'
          update_from_feed(buzz_source)
      elsif buzz_source.buzz_source_type.source_type == 'twitter'
          update_from_twitter(buzz_source)
      # elsif buzz_source.buzz_source_type.source_type == 'html'
      #     update_from_html(buzz_source)
      end
    end
  end
end

   
  # def self.get_feed_urls(buzz_feed_sources)
  #   feed_urls = Array.new
  #   buzz_feed_sources.each do |buzz_source|
  #     feed_url = buzz_source[:uri]
  #     feed_urls = feed_urls.push(feed_url)
  #   end
  # end


  def self.update_from_twitter(buzz_source)
    # buzz_feed_sources.each do |buzz_source|
      twitter_screen_name = buzz_source[:uri]
      Twitter.user_timeline(twitter_screen_name).each do |tweet|
        unless BuzzPost.exists?(:post_guid => tweet.id.to_s)
          BuzzPost.create(
            :post_guid => tweet.id.to_s,
            :buzz_source_id => buzz_source[:id],
            :post_content => tweet.text,
            :post_uri => "https://twiter.com/#{tweet.user.screen_name}/status/#{tweet.id}",
            :post_date_time => tweet.created_at,
            :post_weight => buzz_source[:buzz_weight],
            :scanned_flag => false
          )
          puts "Added ".light_green + tweet.text.light_green + " from " + tweet.user.screen_name
        end
      end
    # end
  end

  def self.update_from_html
  end

  def self.update_from_feed(buzz_source)
    # buzz_feed_sources.each do |buzz_source|
      feed_url = buzz_source[:uri]
      feed = Feedzirra::Feed.fetch_and_parse(feed_url)
      unless feed.nil?
        feed.entries.each do |entry|
          unless BuzzPost.exists?(:post_guid => entry.id)
            stripped_summary = strip_tags(entry.summary)
            BuzzPost.create(
              :buzz_source_id => buzz_source[:id],
              :post_title => entry.title,
              :post_content => stripped_summary,
              :post_uri => entry.url,
              :post_date_time => entry.published,
              :post_guid => entry.id,
              :post_weight => "1",
              :scanned_flag => false
            )
            puts "added ".light_green + entry.title.light_green + " " + entry.url
          else
            puts "skipped ".light_yellow + entry.title.light_yellow+ " " + entry.url
          end
        end
      end
    # end
  end

buzz_source_types = get_buzz_source_types(args)
buzz_sources_array = get_buzz_sources(buzz_source_types)
buzz_posts = get_posts_from_source(buzz_sources_array)

end

puts "Time elapsed #{time_elapsed*1000} milliseconds or #{time_elapsed} seconds"



end



