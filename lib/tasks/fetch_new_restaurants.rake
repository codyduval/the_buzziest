desc "Fetch new restaurants"
task :fetch_new_restaurants_local, [:city, :source, :pages] => :environment do |t,args|
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

