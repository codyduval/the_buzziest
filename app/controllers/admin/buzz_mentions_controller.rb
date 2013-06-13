module Admin
  class BuzzMentionsController < AdminController
    
    def index
      @buzz_mentions = BuzzMention.all
    end

  end
end
