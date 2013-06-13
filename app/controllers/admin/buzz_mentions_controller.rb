module Admin
  class BuzzMentionsController < AdminController
    respond_to :json

    def index
      @buzz_mentions = BuzzMention.all 
    end
  end
end
