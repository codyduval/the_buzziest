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

    old_buzz_mentions = RakeModules::PostCleaner.old_buzz_mentions_to_destroy    
    RakeModules::PostCleaner.destroy_old_buzz_mentions(old_buzz_mentions)

    old_buzz_posts = RakeModules::PostCleaner.old_buzz_posts_to_destroy
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
    require 'benchmark'

    time_elapsed = Benchmark.realtime do
      restaurants = Restaurant.all
      RakeModules::PostScanner.search_for_and_create_buzz_mentions(restaurants)
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
