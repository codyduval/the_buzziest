class BuzzMentionsController < ApplicationController
  
  def index
    @buzz_mentions = BuzzMention.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @buzz_mention = BuzzMention.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @buzz_mention = BuzzMention.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @buzz_mention = BuzzMention.find(params[:id])
  end

  def create
    @buzz_mention = BuzzMention.new(params[:buzz_mention])

    respond_to do |format|
      if @buzz_mention.save
        format.html { redirect_to @buzz_mention, notice: 'Buzz mention was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @buzz_mention = BuzzMention.find(params[:id])

    respond_to do |format|
      if @buzz_mention.update_attributes(params[:buzz_mention])
        format.html { redirect_to @buzz_mention, notice: 'Buzz mention was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end


  def destroy
    @buzz_mention = BuzzMention.find(params[:id])
    @buzz_mention.destroy

    respond_to do |format|
      format.html { redirect_to buzz_mentions_url }
    end
  end
end