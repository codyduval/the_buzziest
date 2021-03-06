require 'nokogiri'
require 'open-uri'

module Fetch
  module RestaurantNames
    class Client

      attr_reader :url, :name_list, :city  
      
      def initialize(source, pages=1)
        @url = source[:uri]
        @node = source[:x_path_nodes]
        @city = source[:city]
        @pages = pages
        @name_list = []
      end

      def fetch_and_parse
        (1..@pages).each do |page| 
          url_page = @url + "#{(page)}"
          html = get(url_page)
          parse(html)
        end
      end

      private

      def parse(html)
        doc = Nokogiri::HTML(html)
        restaurant_names = doc.xpath(@node)
        restaurant_names.each do |restaurant_name|
          restaurant = {}
          restaurant[:name] = restaurant_name.text
          restaurant[:city] = @city
          @name_list << restaurant 
        end
      end

      def get(url)
        open(url, "User-Agent" => 'Mozilla/5.0 (Macintosh; U; 
             Intel Mac OS X 10_5_2; cs-cz) AppleWebKit/525.13 (KHTML,
             like Gecko) Version/3.1 Safari/525.13')
      end

    end
  end
end

