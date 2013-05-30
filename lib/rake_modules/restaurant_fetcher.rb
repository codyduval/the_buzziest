require 'nokogiri'
require 'open-uri'

module RakeModules
  module RestaurantFetcher

    def self.get_and_create_new_restaurants(pages)
      restaurant_list_sources.each do |source|
        puts "Visiting #{source.name}".cyan 
        remote_source_client = client(source, pages)
        remote_source_client.fetch_and_parse
        Restaurant.batch_create_from_remote(remote_source_client)
      end
    end

   private 

    def self.client(source, pages)
      @client = Fetch::RestaurantNames::Client.new(source, pages) 
    end

    def self.restaurant_list_sources
      restaurant_list_sources = BuzzSource.where(:buzz_source_type => 
                                                 "restaurant_list")
    end

  end
end
