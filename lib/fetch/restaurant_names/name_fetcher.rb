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

    end
end
