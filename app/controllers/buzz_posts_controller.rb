class BuzzPostsController < ApplicationController
  # GET /buzz_posts
  # GET /buzz_posts.json
  def index
    @buzz_posts = BuzzPost.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @buzz_posts }
    end
  end

  # GET /buzz_posts/1
  # GET /buzz_posts/1.json
  def show
    @buzz_post = BuzzPost.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @buzz_post }
    end
  end

  # GET /buzz_posts/new
  # GET /buzz_posts/new.json
  def new
    @buzz_post = BuzzPost.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @buzz_post }
    end
  end

  # GET /buzz_posts/1/edit
  def edit
    @buzz_post = BuzzPost.find(params[:id])
  end

  # POST /buzz_posts
  # POST /buzz_posts.json
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

  # PUT /buzz_posts/1
  # PUT /buzz_posts/1.json
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

  # DELETE /buzz_posts/1
  # DELETE /buzz_posts/1.json
  def destroy
    @buzz_post = BuzzPost.find(params[:id])
    @buzz_post.destroy

    respond_to do |format|
      format.html { redirect_to buzz_posts_url }
      format.json { head :no_content }
    end
  end
end
