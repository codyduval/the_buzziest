require "minitest_helper"
require "#{Rails.root}/lib/fetcher/restaurant/client.rb"

module Fetcher
  module Restaurant
    describe Client do
      it "#initialize" do
        url = "http://www.testurl.com"
        node = "node"
        client = Client.new(url, node, 1)
        client.url.must_equal url
      end
    end
  end
end
  
