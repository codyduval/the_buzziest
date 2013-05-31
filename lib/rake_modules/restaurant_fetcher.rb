require 'nokogiri'
require 'open-uri'

module RakeModules
  module RestaurantFetcher

    def self.get_and_create_new_restaurants(pages)
      progress_bar = ProgressBar.create(:format =>"%C %t %e %b", 
                                        :title => "restaurant sources to check...", 
                                        :total => restaurant_list_sources.count)
      restaurant_list_sources.each do |source|
        remote_source_client = client(source, pages)
        remote_source_client.fetch_and_parse
        Restaurant.batch_create_from_remote(remote_source_client)
        progress_bar.increment
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
