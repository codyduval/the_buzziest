desc "This task is called by the Heroku scheduler add-on"

task :update_scores => :environment do

  Raven.capture do

    buzz_mentions = BuzzMention.not_ignored 
    RakeModules::ScoreUpdater.decay_buzz_mention_scores(buzz_mentions)
    RakeModules::ScoreUpdater.update_total_scores

  end
end


task :cleanup_posts => :environment do

  Raven.capture do

    old_buzz_mentions = RakeModules::PostCleaner.old_buzz_mentions    
    RakeModules::PostCleaner.destroy_old_buzz_mentions(old_buzz_mentions)

    old_buzz_posts = RakeModules::PostCleaner.old_buzz_posts
    RakeModules::PostCleaner.destroy_old_buzz_posts(old_buzz_posts)

    RakeModules::PostCleaner.update_counter_caches

    puts "All done.".green

  end
end


task :fetch_restaurants => :environment do

  Raven.capture do

    require 'benchmark'
    time_elapsed = Benchmark.realtime do

      pages_to_scrape = 2
      start_total = Restaurant.count

      RakeModules::RestaurantFetcher.get_and_create_new_restaurants(pages_to_scrape)

      end_total = Restaurant.count
      total_added = end_total - start_total 
      puts "Restaurants added to db: ".green + total_added.to_s.green 
      puts "Total restaurants db: ".green + end_total.to_s.green 
    end
     puts "Time elapsed: #{time_elapsed} seconds"
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


task :fetch_posts => :environment do 

  Raven.capture do
    require 'benchmark'
    time_elapsed = Benchmark.realtime do
      start_total = BuzzPost.count

      rss_feeds = BuzzSource.all_feeds
      twitter_sources = BuzzSource.all_twitter
      
      puts "Fetching content from twitter...."
      RakeModules::BuzzPostFetcher.get_and_create_buzz_posts_twitter(twitter_sources)
      puts "Fetching content from rss feeds..."
      RakeModules::BuzzPostFetcher.get_and_create_buzz_posts_feed(rss_feeds)

      end_total = BuzzPost.count
      total_added = end_total - start_total 
      puts "Posts added to db: ".green + total_added.to_s.green 
      puts "Total posts in db: ".green + end_total.to_s.green 
    end
    puts "Total time elapsed #{time_elapsed} seconds".green
  end
end
