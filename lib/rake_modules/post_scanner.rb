module RakeModules 
  module PostScanner 

    def self.search_for_and_create_buzz_mentions(restaurants)
      search_hits = BuzzPost.search_for_mentions(restaurants)
      BuzzMention.batch_create_from_search!(search_hits)
    end

  end
end

