require 'nokogiri'
require 'open-uri'

module Fetch
  module TwitterHandle 
    class Client

      attr_reader :url, :twitter_handle, :restaurant_name 
      
      def initialize(restaurant_name)
        @restaurant_name = clean_name(restaurant_name)
        @url = base_url + @restaurant_name 
      end

      def fetch_and_parse
        fetched_html = get(@url)
        @twitter_handle = parse(fetched_html)
      end


      private

      def base_url
        base_url = "https://twitter.com/search/users?q=" 
      end

      def node
        node = "//@data-screen-name"
      end

      def get(url)
        open(url, "User-Agent" => 'Mozilla/5.0 (Macintosh; U; 
            Intel Mac OS X 10_5_2; cs-cz) AppleWebKit/525.13 
            (KHTML, like Gecko) Version/3.1 Safari/525.13' )
      end

      def clean_name(restaurant_name)
         stripped_restaurant_name=restaurant_name.gsub(/[^0-9a-z ]/i, '')
         stripped_restaurant_name_no_spaces=stripped_restaurant_name.gsub(/ /, '%20')
      end

      def parse(html)
        doc = Nokogiri::HTML(html)
        twitter_handle = doc.at_xpath(node)
        unless twitter_handle.nil?
          twitter_handle = "@" + twitter_handle.value
        else
          twitter_handle = "tbd"
        end
      end

    end
  end
end

