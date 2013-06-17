module Admin
  class BuzzMentionsController < AdminController
    
    def index
      @buzz_mentions = BuzzMention.find(:all, :order=>"id DESC") 
    end

  end
end
