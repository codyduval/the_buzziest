class Admin::BuzzMentionsController < ApplicationController
  respond_to :json

  def index
    @buzz_mentions = BuzzMention.all 
  end
end
