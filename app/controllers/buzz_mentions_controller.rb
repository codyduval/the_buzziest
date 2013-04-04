class BuzzMentionsController < ApplicationController
  
  load_and_authorize_resource
  
  def index
    @buzz_mentions = BuzzMention.paginate(:page => params[:page], :per_page => params[:per_page]).order(sort_column + ' ' + sort_direction)

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
    @buzz_mention.update_attributes!(params[:buzz_mention])
    respond_to do |format|
      format.html { redirect_to @buzz_mention, notice: 'Buzz mention was successfully updated.' }
      format.js
    end
  end


  def destroy
    @buzz_mention = BuzzMention.find(params[:id])
    @buzz_mention.destroy

    respond_to do |format|
      format.html { redirect_to buzz_mentions_url }
    end
  end

  def toggle_ignore  
    @buzz_mention = BuzzMention.find(params[:id])  
    @buzz_mention.toggle!(:ignore)  

    respond_to do |format|
      format.js
    end 
  end

  def per_page
   params[:per_page] ||= 50
  end

private
  def sort_column
    BuzzMention.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end