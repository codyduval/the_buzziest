desc "Fetch all twitter handles"
task :fetch_all_twitter_handles_local => :environment do

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