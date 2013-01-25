desc "This task is called by the Heroku scheduler add-on"

task :fetch_new_restaurants => :environment do 
  
  require 'nokogiri'
  require 'open-uri'
  require 'benchmark'

  def self.fuzzy_match(name)
    Restaurant.search_by_restaurant_name(name)
  end

  time_elapsed = Benchmark.realtime do

  @added_count = 0
  @skipped_count = 0
  @full_restaurant_name_list = Array.new
  number_of_pages_to_scrape = 2
  city = MasterCities.get_city(:nyc)
  restaurant_list_sources = BuzzSource.where("buzz_source_type = ? AND city = ?","restaurant_list", city)
    
  def self.fetch_restaurant_names(pages,restaurant_list_source)
    (1..pages).each do |page|
      url = restaurant_list_source.uri + "#{(page)}"
      node = restaurant_list_source.x_path_nodes
      puts "Visting #{url}".cyan
      doc = Nokogiri::HTML(open(url, "User-Agent" => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_2; cs-cz) AppleWebKit/525.13 (KHTML, like Gecko) Version/3.1 Safari/525.13' ))
      restaurant_names = doc.xpath(node)
      restaurant_names.each do |restaurant_name|
        puts restaurant_name.text
        @full_restaurant_name_list.push(restaurant_name.text)
      end
    end
  end

  def self.add_restaurant_names_to_db(full_restaurant_name_list,city)
    puts "Attempting to add ".light_green + full_restaurant_name_list.count.to_s + " restaurants into to the database.".light_green
    full_restaurant_name_list.each do |name|
      puts name.light_white
      searched_restaurant = fuzzy_match(name)
      if searched_restaurant.empty?
        @restaurant = Restaurant.find_or_initialize_by_name(name)
        # @restaurant.city_id = city
        @restaurant.city = city
        fetch_restaurant_twitter_handle(@restaurant)
        @restaurant.save
        puts '*added to db*'.light_green
        @added_count = @added_count + 1
      else
        puts '**skipped - already in db**'.light_yellow
        @skipped_count = @skipped_count + 1
      end
    end
  end

  def self.fetch_restaurant_twitter_handle(restaurant)
    stripped_restaurant_name=restaurant.name.gsub(/[^0-9a-z ]/i, '')
    stripped_restaurant_name_no_spaces=stripped_restaurant_name.gsub(/ /, '%20')
    url = "https://twitter.com/search/users?q=#{(stripped_restaurant_name_no_spaces)}"
    node = "//@data-screen-name"
    puts "Visting #{url}".cyan
    doc = Nokogiri::HTML(open(url, "User-Agent" => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_2; cs-cz) AppleWebKit/525.13 (KHTML, like Gecko) Version/3.1 Safari/525.13' ))
    twitter_handle = doc.at_xpath(node)
    unless twitter_handle.nil?
      valid_twitter_handle = "@" + twitter_handle.value
      restaurant.twitter_handle = valid_twitter_handle
      restaurant.save
    end
  end

  restaurant_list_sources.each do |restaurant_list_source|
    fetch_restaurant_names(number_of_pages_to_scrape,restaurant_list_source)
  end

  add_restaurant_names_to_db(@full_restaurant_name_list,city)

  
  total_count = @skipped_count + @added_count
  total_restaurants_in_db = Restaurant.count
  puts "\r \r"
  puts "#{total_count}".light_cyan + " restaurants found"
  puts "#{@added_count}".light_green + " successfully added"
  puts "#{@skipped_count}".light_yellow + " skipped (duplicates)"
  puts "#{total_restaurants_in_db}".green + " total restaurants in database"

  end
puts "Time elapsed #{time_elapsed*1000} milliseconds or #{time_elapsed} seconds"
end



task :scan_posts_for_buzz => :environment do
require 'benchmark'

  def self.scan_posts(restaurant)
    if restaurant.exact_match == true
      puts "Scanning all posts for an exact match of ".light_yellow + restaurant.name
      BuzzPost.search_by_post(restaurant.name)
    else
      puts "Scanning all posts for a regular match on ".light_white+ restaurant.name
      BuzzPost.search_by_post(restaurant.name)
    end
  end

  def self.mark_as_scanned
    unscanned_posts = BuzzPost.where("scanned_flag = 'false'")
    unscanned_posts.each do |unscanned_post|
      unscanned_post.scanned_flag = true
    end
  end

  def self.get_restaurant_names(restaurants)
    restaurant_names = Array.new
    restaurants.each do |restaurant|
      restaurant_name = restaurant[:name]
      restaurant_names = restaurant_names.push(restaurant_name)
    end
  end

  def self.scan_restaurants(restaurants)
    restaurants.each do |restaurant|
      unless restaurant.skip_scan == true
        scan_results = scan_posts(restaurant)
        scan_results.each do |result|
          restaurant = Restaurant.find_by_name(restaurant.name)
          unless BuzzMention.exists?(:buzz_post_id => result[:id], :restaurant_id => restaurant[:id])
            @buzz_mention = BuzzMention.create(
              :restaurant_id => restaurant[:id],
              :buzz_post_id => result[:id],
              :buzz_score => result[:post_weight]
            )
            puts "Found new buzz for #{restaurant.name} in post id #{result.id} posted on #{@buzz_mention.buzz_post.buzz_source.name}".light_green
          end
        end
      else
        puts "Skipping ".light_yellow + restaurant.name
      end
    end
  end

  time_elapsed = Benchmark.realtime do

  all_restaurants = Restaurant.all
  # all_restaurant_names = get_restaurant_names(all_restaurants)
  scan_restaurants(all_restaurants)

  end

  puts "Time elapsed #{time_elapsed*1000} milliseconds or #{time_elapsed} seconds"
end


task :fetch_all_twitter_handles => :environment do

  require 'nokogiri'
  require 'open-uri'


  def self.fetch_restaurant_twitter_handle(restaurant)
    stripped_restaurant_name=restaurant.name.gsub(/[^0-9a-z ]/i, '')
    stripped_restaurant_name_no_spaces=stripped_restaurant_name.gsub(/ /, '%20')
    puts "Getting " + stripped_restaurant_name
    url = "https://twitter.com/search/users?q=#{(stripped_restaurant_name_no_spaces)}"
    node = "//@data-screen-name"
    puts "Visting #{url}".cyan
    doc = Nokogiri::HTML(open(url, "User-Agent" => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_2; cs-cz) AppleWebKit/525.13 (KHTML, like Gecko) Version/3.1 Safari/525.13' ))
    twitter_handle = doc.at_xpath(node)
    unless twitter_handle.nil?
      valid_twitter_handle = "@" + twitter_handle.value
      restaurant.twitter_handle = valid_twitter_handle
      restaurant.save
    end
  end

  restaurants = Restaurant.all
  restaurants.each do |restaurant|
    if restaurant.twitter_handle.blank?
      fetch_restaurant_twitter_handle(restaurant)
    end
  end
end


task :fetch_buzz_posts, [:city, :source_type] => :environment do |t, args|
  args.with_defaults(:city => "nyc", :source_type => "all")

  include ActionView::Helpers::SanitizeHelper
  require 'benchmark'

def self.get_buzz_source_types(args)
  unless args.source_type == "all"
    # buzz_source_types = BuzzSourceType.where(:source_type=> args.source_type)
    buzz_source_types = args.source_type
  else
    # buzz_source_types = BuzzSourceType.where("source_type = 'feed' OR source_type = 'twitter'")
    buzz_source_types = ["feed","twitter"]
  end
end

def self.get_buzz_sources(buzz_source_types)
  buzz_sources_array = Array.new
  buzz_source_types.each do |buzz_source_type|
    buzz_source = BuzzSource.where(:buzz_source_type  => buzz_source_type)
    buzz_sources_array.push(buzz_source)
  end
  return buzz_sources_array
end

def get_posts_from_source(buzz_sources_array)
  buzz_sources_array.each do |buzz_sources|
    buzz_sources.each do |buzz_source|
      if buzz_source.buzz_source_type == "feed"
          update_from_feed(buzz_source)
      elsif buzz_source.buzz_source_type == "twitter"
          update_from_twitter(buzz_source)
      end
    end
  end
end

   
  def self.update_from_twitter(buzz_source)
    # buzz_feed_sources.each do |buzz_source|
      twitter_screen_name = buzz_source[:uri]
      Twitter.user_timeline(twitter_screen_name).each do |tweet|
        unless BuzzPost.exists?(:post_guid => tweet.id.to_s)
          BuzzPost.create(
            :post_guid => tweet.id.to_s,
            :buzz_source_id => buzz_source[:id],
            :post_content => tweet.text,
            :post_title => tweet.text,
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

  time_elapsed = Benchmark.realtime do

  buzz_source_types = get_buzz_source_types(args)
  buzz_sources_array = get_buzz_sources(buzz_source_types)
  buzz_posts = get_posts_from_source(buzz_sources_array)

  end

  puts "Time elapsed #{time_elapsed*1000} milliseconds or #{time_elapsed} seconds"
end