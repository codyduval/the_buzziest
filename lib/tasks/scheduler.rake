desc "This task is called by the Heroku scheduler add-on"

task :update_scores => :environment do

  Raven.capture do
  # captures any exceptions which happen in this block and notify via Sentry

  def self.calculate_decayed_scores
    puts "Decaying scores"
    buzz_mentions = BuzzMention.where(:ignore => false)
    counter = buzz_mentions.count
    buzz_mentions.each do |buzz_mention|
      decayed_score = buzz_mention.calculate_decayed_buzz_score
      buzz_mention.decayed_buzz_score = decayed_score
      buzz_mention.save
      counter = counter -1
      print "\r#{counter} to go..."
    end
    puts "...and done!"
  end

  def self.update_total_scores
    puts "Updating score table"
    restaurants = Restaurant.where("buzz_mentions_count >= 1")
    counter = restaurants.count
    restaurants.each do |restaurant|
      total_score = BuzzMention.where(:restaurant_id => restaurant.id, :ignore => false).sum("decayed_buzz_score")
      BuzzScore.create({ :restaurant_id => restaurant.id, :buzz_score => total_score})
      counter = counter -1
      print "\r#{counter} to go..."
    end
    puts "...and done!"
  end

  calculate_decayed_scores
  update_total_scores

  end
end


task :cleanup_posts => :environment do

  Raven.capture do
  # captures any exceptions which happen in this block and notify via Sentry

  def self.old_posts_ids(age_in_days)
    old_posts = BuzzPost.where("post_date_time < :days", {:days => age_in_days.day.ago})
    old_posts_ids = []

    old_posts.each do |post|
      old_posts_ids << post.id
    end

    return old_posts_ids
  end

  def self.mentioned_posts_ids
    mentioned_posts = BuzzMention.all
    mentioned_posts_ids = []

    mentioned_posts.each do |post|
      mentioned_posts_ids << post.buzz_post_id
    end

    return mentioned_posts_ids
  end

  def self.find_posts_to_destroy(old_posts_ids, mentioned_posts_ids)
    post_ids_to_destroy = []
    post_ids_to_destroy = (old_posts_ids - mentioned_posts_ids)
    BuzzPost.find_all_by_id(post_ids_to_destroy)
  end

  def self.destroy_old_posts(posts_to_destroy)
    puts "Destroying ".light_red + posts_to_destroy.count.to_s.light_red + " posts".light_red
    BuzzPost.destroy(posts_to_destroy)
  end

  def self.find_old_buzz_mentions
    old_buzz_mentions_ids = []
    old_buzz_mentions = BuzzMention.where("decayed_buzz_score < ?",0.05)
    old_buzz_mentions.each do |mention|
      old_buzz_mentions_ids << mention.id
    end
    BuzzMention.find_all_by_id(old_buzz_mentions_ids)
  end

  def self.destroy_old_buzz_mentions(mentions_to_destroy)
    puts "Destroying ".light_red + mentions_to_destroy.count.to_s.light_red + " mentions".light_red
    BuzzMention.destroy(mentions_to_destroy)
  end

  posts_to_destroy = find_posts_to_destroy(old_posts_ids(30), mentioned_posts_ids)
  destroy_old_posts(posts_to_destroy)
  mentions_to_destroy = find_old_buzz_mentions
  destroy_old_buzz_mentions(mentions_to_destroy)
  end
end


task :fetch_restaurants => :environment do

  Raven.capture do
  # captures any exceptions which happen in this block and notify via Sentry

  require 'nokogiri'
  require 'open-uri'
  require 'benchmark'

  def self.fuzzy_match(name)
    fuzzy_match = Restaurant.search do
      fulltext %Q/"#{name}"/
    end
    fuzzy_match = fuzzy_match.results

    return fuzzy_match
  end

  time_elapsed = Benchmark.realtime do

  @added_count = 0
  @skipped_count = 0
  @full_restaurant_name_list = Array.new
  number_of_pages_to_scrape = 2
  cities = MasterCities.get_all_city_names

  def self.fetch_restaurant_names(pages,restaurant_list_source)
    single_source_restaurant_name_list = Array.new
    (1..pages).each do |page|
      url = restaurant_list_source.uri + "#{(page)}"
      node = restaurant_list_source.x_path_nodes
      puts "Visting #{url}".cyan
      doc = Nokogiri::HTML(open(url, "User-Agent" => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_2; cs-cz) AppleWebKit/525.13 (KHTML, like Gecko) Version/3.1 Safari/525.13' ))
      restaurant_names = doc.xpath(node)
      restaurant_names.each do |restaurant_name|
        puts restaurant_name.text
        single_source_restaurant_name_list.push(restaurant_name.text)
      end
    end
    return single_source_restaurant_name_list
  end

  def self.add_restaurant_names_to_db(full_restaurant_name_list,city)
    puts "Attempting to add ".light_green + full_restaurant_name_list.count.to_s + " restaurants into to the database.".light_green
    full_restaurant_name_list.each do |name|
      puts name.light_white
      searched_restaurant = fuzzy_match(name)
      if searched_restaurant.empty?
        @restaurant = Restaurant.find_or_initialize_by_name(name)
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

  cities.each do |city|
    full_restaurant_name_list = Array.new
    restaurant_list_sources = BuzzSource.where("buzz_source_type = ? AND city = ?","restaurant_list", city)
    restaurant_list_sources.each do |restaurant_list_source|
      full_restaurant_name_list.concat(fetch_restaurant_names(number_of_pages_to_scrape,restaurant_list_source))
    end
    add_restaurant_names_to_db(full_restaurant_name_list,city)
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
end



task :scan_posts => :environment do

  Raven.capture do
  # captures any exceptions which happen in this block and notify via Sentry

  require 'benchmark'

  def self.search_by_post(name)
    buzz_post_search_results = BuzzPost.search do
      fulltext name do
        highlight :post_content
      end
    end
    buzz_post_search_hits = buzz_post_search_results.hits

    return buzz_post_search_hits
  end

  def self.search_phrase_by_post(name)
    buzz_post_search_results = BuzzPost.search do
      fulltext %Q/"#{name}"/ do
        highlight :post_content
      end
    end
    buzz_post_search_hits = buzz_post_search_results.hits

    return buzz_post_search_hits
  end

  def self.search_phrase_by_post_and_city(name,city)
    buzz_post_search_results = BuzzPost.search do
      with(:city, city)
      fulltext %Q/"#{name}"/ do
        highlight :post_content
      end
    end
    buzz_post_search_hits = buzz_post_search_results.hits

    return buzz_post_search_hits
  end

  def self.scan_posts(restaurant)
    if restaurant.exact_match == true
      puts "Scanning posts for an exact match of ".light_yellow + restaurant.name
      search_phrase_by_post_and_city(restaurant.name, restaurant.city)
    else
      puts "Scanning posts for a regular match on ".light_white + restaurant.name
      search_phrase_by_post_and_city(restaurant.name, restaurant.city)
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
        scan_results_hits = scan_posts(restaurant)
        scan_results_hits.each do |hit|
          restaurant = Restaurant.find_by_name(restaurant.name)
          unless BuzzMention.exists?(:buzz_post_id => hit.primary_key.to_i, :restaurant_id => restaurant[:id])
            initial_buzz_score = BuzzPost.where(:id => hit.primary_key.to_i).first.post_weight
            @buzz_mention = BuzzMention.create(
              :restaurant_id => restaurant[:id],
              :buzz_post_id => hit.primary_key.to_i,
              :buzz_score => initial_buzz_score,
              :decayed_buzz_score => initial_buzz_score
            )
            @buzz_mention.update_decayed_buzz_score!
            puts "Buzz found in post_id #{hit.primary_key.to_i} published in #{@buzz_mention.buzz_post.buzz_source.name} on #{@buzz_mention.buzz_post.post_date_time}".light_green
            puts "Giving initial buzz score of #{@buzz_mention.decayed_buzz_score}".light_cyan
            hit.highlights(:post_content).each do |highlight|
              @buzz_mention_highlight = BuzzMentionHighlight.create(
              :buzz_mention_highlight_text => highlight.format,
              :buzz_mention_id => @buzz_mention.id
              )
            end

          end
        end
      else
        puts "Skipping ".light_yellow + restaurant.name
      end
    end
  end

  time_elapsed = Benchmark.realtime do

  all_restaurants = Restaurant.all
  scan_restaurants(all_restaurants)

  end

  puts "Done in #{time_elapsed} seconds."
  end
end


task :fetch_all_twitter_handles => :environment do
  Raven.capture do
  # captures any exceptions which happen in this block and notify via Sentry

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
end


task :fetch_posts, [:city, :source_type] => :environment do |t, args|
  args.with_defaults(:city => "nyc", :source_type => "all")

  Raven.capture do
  # captures any exceptions which happen in this block and notify via Sentry

  include ActionView::Helpers::SanitizeHelper
  require 'benchmark'

  def self.get_buzz_source_types(args)
    unless args.source_type == "all"
      buzz_source_types = args.source_type
    else
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
    twitter_screen_name = buzz_source[:uri]
    Twitter.user_timeline(twitter_screen_name).each do |tweet|
      unless BuzzPost.exists?(:post_guid => tweet.id.to_s)
        BuzzPost.create(
          :post_guid => tweet.id.to_s,
          :buzz_source_id => buzz_source[:id],
          :post_content => tweet.text,
          :post_title => tweet.text,
          :post_uri => "https://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id}",
          :post_date_time => tweet.created_at,
          :post_weight => buzz_source[:buzz_weight],
          :scanned_flag => false,
          :city => buzz_source[:city]
        )
        puts "Added tweet".light_green + tweet.text + " from " + tweet.user.screen_name
      end
    end
  end

  def self.update_from_html
  end

  def self.update_from_feed(buzz_source)
    feed_url = buzz_source[:uri]
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    exist_count = 0
    too_old_count = 0
    new_entries = []
    unless (feed.nil? || feed == 0)
      print "Found #{feed.entries.count} entries in #{buzz_source[:name]}".light_cyan
      feed.entries.each do |entry|
        print ".".light_cyan
        if BuzzPost.exists?(:post_guid => entry.id)
          exist_count += 1
        elsif entry.published < 25.day.ago
          too_old_count += 1
        else
          if entry.content.nil?
            stripped_summary = strip_tags(entry.summary)
          else
            stripped_summary = strip_tags(entry.content)
          end
          BuzzPost.create(
            :buzz_source_id => buzz_source[:id],
            :post_title => entry.title,
            :post_content => stripped_summary,
            :post_uri => entry.url,
            :post_date_time => entry.published,
            :post_guid => entry.id,
            :post_weight => "1",
            :scanned_flag => false,
            :city => buzz_source[:city]
          )
          new_entries << entry
        end
      end
    end
    new_entries.each do |entry|
      print "\nAdding ".light_green + entry.title + " " + entry.url
    end
    puts "\n#{exist_count} are older than 25 days and won't be added.".light_yellow
    puts "#{too_old_count} already exist and won't be added.".light_yellow
  end

  time_elapsed = Benchmark.realtime do

  buzz_source_types = get_buzz_source_types(args)
  buzz_sources_array = get_buzz_sources(buzz_source_types)
  buzz_posts = get_posts_from_source(buzz_sources_array)

  end

  puts "Total time elapsed #{time_elapsed} seconds".green
  end
end
