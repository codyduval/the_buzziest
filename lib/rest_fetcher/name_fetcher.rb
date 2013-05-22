
module Fetcher
    class NameFetcher

    attr_accessor :all_names

    def initialize(pages, client)
      @pages = pages
      @client = client
      @all_names = []
      @added_count = 0
      @skipped_count = 0
    end

    def fetch_restaurant_names
      (1..@pages).each do |page| 
        puts "Fetching page " + page.to_s
        @client.fetch(page)
      end
      @all_names << @client.name_list
      @all_names.flatten!
    end

    def add_restaurants
      @all_names.each do |name|
        #unless duplicate?(name[:name])
          restaurant = Restaurant.find_or_initialize_by_name(name[:name])
          restaurant.city = name[:city]
          #fetch_restaurant_twitter_handle(@restaurant)
          restaurant.save
        #  puts "#{name[:name]} is new, added to db".green
        #  @added_count += 1
        #else
        #  puts "#{name[:name]} is a duplicate, skipping".yellow
        #  @skipped_count += 1
        #end
      end
    end

    end
end
