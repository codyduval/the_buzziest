desc "Scan BuzzPosts for restaurant mentions"
task :scan_posts_for_buzz => :environment do

require 'benchmark'

 
time_elapsed = Benchmark.realtime do

  def self.scan_posts(restaurant_name)

      if restaurant_name.exact_match == true
        puts "Scanning all posts for an exact match of ".light_yellow + restaurant_name.name
        BuzzPost.search do
          fulltext '#{restaurant_name.name}'
        end
      else
        puts "Scanning all posts for a regular match on ".light_white+ restaurant_name.name
        BuzzPost.search do
          fulltext restaurant_name.name
        end
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

  def self.scan_restaurants(restaurant_names)
    restaurant_names.each do |restaurant_name|
      unless restaurant_name.skip_scan == true
        scan_results = scan_posts(restaurant_name).results
        scan_results.each do |result|
          restaurant= Restaurant.find_by_name(restaurant_name.name)
          unless BuzzMention.exists?(:buzz_post_id => result[:id], :restaurant_id => restaurant[:id])
            @buzz_mention = BuzzMention.create(
              :restaurant_id => restaurant[:id],
              :buzz_post_id => result[:id],
              :buzz_score => result[:post_weight]
            )
            puts "Found new buzz for #{restaurant.name} in post id #{result.id} posted on #{@buzz_mention.buzz_post.buzz_source.name}"
          end
        end
      else
        puts "Skipping ".light_yellow + restaurant_name.name
      end
    end
  end

all_restaurants = Restaurant.all
all_restaurant_names = get_restaurant_names(all_restaurants)
scan_restaurants(all_restaurant_names)


end
puts "Time elapsed #{time_elapsed*1000} milliseconds or #{time_elapsed} seconds"

end

