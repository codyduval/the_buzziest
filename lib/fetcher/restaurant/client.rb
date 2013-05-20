require 'nokogiri'
require 'open-uri'
require 'benchmark'

module Fetcher
  module Restaurant
    class Client
      
      def initialize(url)
        @url = url
      end

      def fetch
        html = get(@url)
        parse(html)
      end

      def parse(html)
        doc = Nokogiri::HTML(html)
      end

      private

      def get(url)
        open(url, "User-Agent" => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_2; cs-cz) AppleWebKit/525.13 (KHTML, like Gecko) Version/3.1 Safari/525.13' ))
      end

    end
  end
end

