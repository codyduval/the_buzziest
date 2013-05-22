require 'nokogiri'
require 'open-uri'

module RakeModules
  module RestaurantFetcher

    @added_count = 0
    @skipped_count = 0

    def self.get_new_restaurants(pages)
      restaurant_list_sources.each do |source|
        name_fetcher = Fetcher::NameFetcher.new(pages, client(source))
        puts "Visiting #{source.name}".cyan 
        name_fetcher.fetch_restaurant_names
        name_fetcher.add_restaurants
      end
      puts "Added #{@added_count} new restaurants".cyan
      puts "Skipped #{@skipped_count} restaurants".cyan
    end

   private 

    def self.client(source)
      @client = Fetcher::Client.new(source[:uri], source[:x_path_nodes], source[:city])
    end

    def self.restaurant_list_sources
      restaurant_list_sources = BuzzSource.where(:buzz_source_type => "restaurant_list")
    end

  end
end
