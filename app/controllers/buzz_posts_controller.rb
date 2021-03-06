class BuzzPostsController < ApplicationController
  helper_method :sort_column, :sort_direction

  load_and_authorize_resource

  def index
    # @buzz_posts = BuzzPost.all
    @buzz_posts = BuzzPost.paginate(:page => params[:page], :per_page => params[:per_page]).order(sort_column + ' ' + sort_direction)
    BuzzPost.paginated_for_index(per_page, page)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @buzz_posts }
    end
  end

  def show
    @buzz_post = BuzzPost.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @buzz_post }
    end
  end

  def new
    @buzz_post = BuzzPost.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @buzz_post }
    end
  end

  def edit
    @buzz_post = BuzzPost.find(params[:id])
  end

  def create
    @buzz_post = BuzzPost.new(params[:buzz_post])

    respond_to do |format|
      if @buzz_post.save
        format.html { redirect_to @buzz_post, notice: 'Buzz post was successfully created.' }
        format.json { render json: @buzz_post, status: :created, location: @buzz_post }
      else
        format.html { render action: "new" }
        format.json { render json: @buzz_post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @buzz_post = BuzzPost.find(params[:id])

    respond_to do |format|
      if @buzz_post.update_attributes(params[:buzz_post])
        format.html { redirect_to @buzz_post, notice: 'Buzz post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @buzz_post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @buzz_post = BuzzPost.find(params[:id])
    @buzz_post.destroy

    respond_to do |format|
      format.html { redirect_to buzz_posts_url }
      format.json { head :no_content }
    end
  end

  private
  def sort_column
    BuzzPost.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def per_page
    params[:per_page] ||= 50
  end

  def page 
    params[:page] ||= 1
  end

end
