require 'nokogiri'
require 'open-uri'

module Fetcher
  module Restaurant
    class Client
    attr_accessor :url  
      
      def initialize(url, node, page=1)
        @url = url + "#{(page)}"
        @page = page
        @node = node
      end

      def fetch
        html = get(@url)
        parse(html)
      end

      def parse(html)
        restaurant_name_list = []
        doc = Nokogiri::HTML(html)
        restaurant_names = doc.xpath(@node)
        restaurant_names.each do |restaurant_name|
          puts restaurant_name.text
          restaurant_name_list.push(restaurant_name.text)
        end
        restaurant_name_list
      end

      private

      def get(url)
        open(url, "User-Agent" => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_2; cs-cz) AppleWebKit/525.13 (KHTML, like Gecko) Version/3.1 Safari/525.13' )
      end

    end
  end
end

