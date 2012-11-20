desc "Scan BuzzPosts for restaurant mentions"
task :scan_posts_for_buzz => :environment do

  def self.scan_posts(restaurant_name)
      BuzzPost.search do
        fulltext restaurant_name
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
      scan_results = scan_posts(restaurant_name.name).results
      scan_results.each do |result|
        puts result[:id]
        restaurant= Restaurant.find_by_name(restaurant_name.name)
        unless BuzzMention.exists?(:buzz_post_id => result[:id], :restaurant_id => restaurant[:id])
          BuzzMention.create(
            :restaurant_id => restaurant[:id],
            :buzz_post_id => result[:id],
            :buzz_score => result[:post_weight]
          )
          puts "Found buzz for ".light_green + restaurant[:name]
        else
          puts "Skipped, already scanned".light_yellow
        end
      end
    end
  end

all_restaurants = Restaurant.all
all_restaurant_names = get_restaurant_names(all_restaurants)
scan_restaurants(all_restaurant_names)

end

