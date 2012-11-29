desc "Fetch posts that contain restaurant buzz"
task :fetch_buzz_posts => :environment do

  include ActionView::Helpers::SanitizeHelper
  require 'benchmark'

 
  def ask message
    print message
    STDIN.gets.chomp
  end
  
  console_input_which_source_type = '0'
  console_input_which_source_type = ask('Get new posts from (1) RSS feeds (2) Twitter or (3) All? (Enter 1, 2, or 3; anything else to cancel) '.light_white)

time_elapsed = Benchmark.realtime do
   
  def self.get_feed_urls(buzz_feed_sources)
    feed_urls = Array.new
    buzz_feed_sources.each do |buzz_source|
      feed_url = buzz_source[:uri]
      feed_urls = feed_urls.push(feed_url)
    end
  end

  def self.update_from_newsletter
  end

  def self.update_from_twitter(buzz_feed_sources)
    buzz_feed_sources.each do |buzz_source|
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
    end
  end

  def self.update_from_html
  end

  def self.update_from_feed(buzz_feed_sources)
    buzz_feed_sources.each do |buzz_source|
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
    end
  end


  if console_input_which_source_type == '1'
    all_buzz_feed_sources = BuzzSource.where("buzz_source_type_id = '1'")
    update_from_feed(all_buzz_feed_sources)
  elsif console_input_which_source_type == '2'
    all_buzz_twitter_sources = BuzzSource.where("buzz_source_type_id = '3'")
    update_from_twitter(all_buzz_twitter_sources)
  elsif console_input_which_source_type == '3'
    all_buzz_feed_sources = BuzzSource.where("buzz_source_type_id = '1'")
    update_from_feed(all_buzz_feed_sources)
    all_buzz_feed_sources = BuzzSource.where("buzz_source_type_id = '3'")
    update_from_twitter(all_buzz_feed_sources)
  else
    break
  end

end
puts "Time elapsed #{time_elapsed*1000} milliseconds or #{time_elapsed} seconds"

end



