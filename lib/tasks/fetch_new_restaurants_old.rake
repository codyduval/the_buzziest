desc "Fetch new restaurants"
task :fetch_new_restaurants => :environment do
  require 'nokogiri'
  require 'open-uri'
  require 'benchmark'

 


  def self.fuzzy_match(new_restaurant_from_source)
    Restaurant.search_by_restaurant_name(new_restaurant_from_source)
  end

  def ask message
    print message
    STDIN.gets.chomp
  end

  console_input_which_source = '0'
  eater_url = "http://ny.eater.com/archives/categories/status_open.php?page="
  eater_node = '//a[@class="post-title"]'
  tasting_table_url = "http://www.tastingtable.com/dispatch/nyc/all/"
  tasting_table_node = '//h5[@class="opened"]/following-sibling::div[@class="copy"]/h1'
  ny_mag_url = "http://nymag.com/srch?t=restaurant&N=265+334&No=0&Ns=nyml_sort_name"
  ny_mag_node = '//dl[@class="result"]/dt/a'
  thrillist_url = 'http://www.thrillist.com/NY/browse/food/'
  thrillist_node = '//h3[@class="item_header"]/a'
  added_count = 0
  skipped_count = 0


  console_input_which_source = ask('Get new restaurants from (1) Tasting Table, (2) Eater, or (3) NY Mag, (4) Thrillist? (Enter 1, 2, or 3; anything else to cancel) '.light_white)

time_elapsed = Benchmark.realtime do
  
  if console_input_which_source == '1'
    single_page_url = tasting_table_url
    node = tasting_table_node
  elsif console_input_which_source == '2'
    single_page_url = eater_url
    node = eater_node
  elsif console_input_which_source == '3'
    single_page_url = ny_mag_url
    node = ny_mag_node
  elsif console_input_which_source == '4'
    single_page_url = thrillist_url
    node = thrillist_node
  else
    break
  end

  console_input_how_many_pages = ask('How many pages to scan? (1 to 10, anything else to cancel) '.light_white)
  console_input_how_many_pages = console_input_how_many_pages.to_i

  unless (console_input_how_many_pages >= 1) && (console_input_how_many_pages <= 10)
    break
  end

  (1..console_input_how_many_pages).each do |page|
    url = single_page_url + "#{(page)}"
    puts "Visting #{url}".cyan
    doc = Nokogiri::HTML(open(url, "User-Agent" => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_2; cs-cz) AppleWebKit/525.13 (KHTML, like Gecko) Version/3.1 Safari/525.13' ))
    restaurant_names = doc.xpath(node)
    restaurant_names.each do |name|
      new_restaurant_from_source = name.text
      puts new_restaurant_from_source.light_white
      searched_restaurant = fuzzy_match(new_restaurant_from_source)
      if searched_restaurant.empty?
        restaurant = Restaurant.find_or_initialize_by_name(new_restaurant_from_source)
        restaurant.save
        puts '*added to db*'.light_green
        puts '*added to index*'.light_green
        added_count = added_count + 1
      else
        puts '**skipped - already in db**'.light_yellow
        skipped_count = skipped_count + 1
      end
    end
  end

  total_count = skipped_count + added_count
  total_restaurants_in_db = Restaurant.count
  puts "\r \r"
  puts "#{total_count}".light_cyan + " restaurants found"
  puts "#{added_count}".light_green + " successfully added"
  puts "#{skipped_count}".light_yellow + " skipped (duplicates)"
  puts "#{total_restaurants_in_db}".green + " total restaurants in database"

end
puts "Time elapsed #{time_elapsed*1000} milliseconds or #{time_elapsed} seconds"


end

