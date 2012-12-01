desc "This task is called by the Heroku scheduler add-on"

task :fetch_new_restaurants, [:city, :source, :pages] => :environment do |t,args|
  args.with_defaults(:city => "nyc", :source => "all", :pages => 5)

  require 'nokogiri'
  require 'open-uri'
  require 'benchmark'

  def self.fuzzy_match(new_restaurant_from_source)
    Restaurant.search_by_restaurant_name(new_restaurant_from_source)
  end

  time_elapsed = Benchmark.realtime do

    @added_count = 0
    @skipped_count = 0

  if args.source == 'tasting_table'
    restaurant_list_sources = BuzzSource.where(:name => "Tasting Table NY - New Restaurants")
  elsif args.source == 'eater'
    restaurant_list_sources = BuzzSource.where(:name => "Eater NY - New Restaurants")
  elsif args.source == 'ny_mag'
    restaurant_list_sources = BuzzSource.where(:name => "NY Mag - New Restaurants")
  elsif args.source == 'all'
    restaurant_source = BuzzSourceType.where(:source_type => "restaurant_list")
    city = City.where(:short_name => args.city)
    if args.city == 'all'
      restaurant_list_sources = BuzzSource.where(:buzz_source_type_id => restaurant_source.first.id)
    else
      restaurant_list_sources = BuzzSource.where(:buzz_source_type_id => restaurant_source.first.id, :city_id => city.first.id)
    end
  else
    break
  end

  restaurant_list_sources.each do |restaurant_list_source|
    (1..args.pages.to_i).each do |page|
      url = restaurant_list_source.uri + "#{(page)}"
      node = restaurant_list_source.x_path_nodes
      puts "Visting #{url}".cyan
      doc = Nokogiri::HTML(open(url, "User-Agent" => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_2; cs-cz) AppleWebKit/525.13 (KHTML, like Gecko) Version/3.1 Safari/525.13' ))
      restaurant_names = doc.xpath(node)
      restaurant_names.each do |name|
        new_restaurant_from_source = name.text
        puts new_restaurant_from_source.light_white
        searched_restaurant = fuzzy_match(new_restaurant_from_source)
        if searched_restaurant.empty?
          restaurant = Restaurant.find_or_initialize_by_name(new_restaurant_from_source)
          restaurant.city_id = restaurant_list_source.city_id
          restaurant.save
          puts '*added to db*'.light_green
          @added_count = @added_count + 1
        else
          puts '**skipped - already in db**'.light_yellow
          @skipped_count = @skipped_count + 1
        end
      end
    end
  end

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
    unscanned_posts = BuzzPost.where("scanned_flag = 'f'")
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


task :fetch_buzz_posts, [:city, :source_type] => :environment do |t, args|
  args.with_defaults(:city => "nyc", :source_type => "all")

  include ActionView::Helpers::SanitizeHelper
  require 'benchmark'




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

  time_elapsed = Benchmark.realtime do

  buzz_source_types = get_buzz_source_types(args)
  buzz_sources_array = get_buzz_sources(buzz_source_types)
  buzz_posts = get_posts_from_source(buzz_sources_array)

  end

  puts "Time elapsed #{time_elapsed*1000} milliseconds or #{time_elapsed} seconds"
end