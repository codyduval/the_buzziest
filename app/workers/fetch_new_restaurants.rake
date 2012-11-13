desc "Fetch new restaurants"
task :fetch_names => :environment do
  require 'nokogiri'
  require 'open-uri'

  url= "http://www.tastingtable.com/dispatch/nyc/all"
  doc = Nokogiri::HTML(open(url))

  restaurant_names = doc.css("h1 a")
  restaurant_names.each do |name|
    restaurant = Restaurant.find_or_initialize_by_name(name)
    restaurant.name = name
  end
end




