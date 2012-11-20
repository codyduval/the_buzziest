desc "Fetch posts that contain restaurant buzz"
task :fetch_buzz_feeds => :environment do

  include ActionView::Helpers::SanitizeHelper
  
   
  def self.get_feed_urls(buzz_feed_sources)
    feed_urls = Array.new
    buzz_feed_sources.each do |buzz_source|
      feed_url = buzz_source[:uri]
      feed_urls = feed_urls.push(feed_url)
    end
  end

  def self.update_from_newsletter
  end

  def self.update_from_twitter
  end

  def self.update_from_html
  end

  # def self.update_from_feed(feed_urls)
  #   feed_urls.each do |feed_url|
  #     feed = Feedzirra::Feed.fetch_and_parse(feed_url[:uri])
  #     feed.entries.each do |entry|
  #       unless BuzzPost.exists?(:post_guid => entry.id)
  #         stripped_summary = strip_tags(entry.summary)
  #         BuzzPost.create(
  #           :post_title => entry.title,
  #           :post_content => stripped_summary,
  #           :post_uri => entry.url,
  #           :post_date_time => entry.published,
  #           :post_guid => entry.id,
  #           :post_weight => "1",
  #           :scanned_flag => false
  #         )
  #         puts "added ".light_green + entry.title.light_green + " " + entry.url
  #         Sunspot.commit
  #       else
  #         puts "skipped ".light_yellow + entry.title.light_yellow+ " " + entry.url
  #       end
  #     end
  #   end
  # end

  def self.update_from_feed(buzz_feed_sources)
    buzz_feed_sources.each do |buzz_source|
      feed_url = buzz_source[:uri]
      feed = Feedzirra::Feed.fetch_and_parse(feed_url)
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
          Sunspot.commit
        else
          puts "skipped ".light_yellow + entry.title.light_yellow+ " " + entry.url
        end
      end
    end
  end

 # need to change this so that it only gets BuzzSources that are RSS feeds.  Add column to table. Use a where statement (where type=rss)
  all_buzz_feed_sources = BuzzSource.where("source_type = 'feed'")
  update_from_feed(all_buzz_feed_sources)

end



