require 'nokogiri'
require 'open-uri'

module Fetch
  module RemoteBuzzPosts 
    class FeedClient

      attr_accessor :url, :valid_twitter_handle 
      
      def initialize(restaurant_name)
        @url = "https://twitter.com/search/users?q=" 
        @node = "//@data-screen-name"
        @restaurant_name = restaurant_name
      end

      def fetch
        clean_name = clean_name(@restaurant_name)
        url_page = @url + "#{(clean_name)}"
        html = get(url_page)
        parse(html)
      end

      def parse(html)
        doc = Nokogiri::HTML(html)
        twitter_handle = doc.at_xpath(@node)
        unless twitter_handle.nil?
          @valid_twitter_handle = "@" + twitter_handle.value
        else
          @valid_twitter_handle = "tbd"
        end
      end

      private

      def get(url)
        open(url, "User-Agent" => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_2; cs-cz) AppleWebKit/525.13 (KHTML, like Gecko) Version/3.1 Safari/525.13' )
      end

      def clean_name(restaurant_name)
         stripped_restaurant_name=restaurant_name.gsub(/[^0-9a-z ]/i, '')
         stripped_restaurant_name_no_spaces=stripped_restaurant_name.gsub(/ /, '%20')

         return stripped_restaurant_name_no_spaces
      end

    end
  end
end

