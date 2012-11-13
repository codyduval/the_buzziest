class BuzzSourcesController < ApplicationController
  # GET /buzz_sources
  # GET /buzz_sources.json
  def index
    @buzz_sources = BuzzSource.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @buzz_sources }
    end
  end

  # GET /buzz_sources/1
  # GET /buzz_sources/1.json
  def show
    @buzz_source = BuzzSource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @buzz_source }
    end
  end

  # GET /buzz_sources/new
  # GET /buzz_sources/new.json
  def new
    @buzz_source = BuzzSource.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @buzz_source }
    end
  end

  # GET /buzz_sources/1/edit
  def edit
    @buzz_source = BuzzSource.find(params[:id])
  end

  # POST /buzz_sources
  # POST /buzz_sources.json
  def create
    @buzz_source = BuzzSource.new(params[:buzz_source])

    respond_to do |format|
      if @buzz_source.save
        format.html { redirect_to @buzz_source, notice: 'Buzz source was successfully created.' }
        format.json { render json: @buzz_source, status: :created, location: @buzz_source }
      else
        format.html { render action: "new" }
        format.json { render json: @buzz_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /buzz_sources/1
  # PUT /buzz_sources/1.json
  def update
    @buzz_source = BuzzSource.find(params[:id])

    respond_to do |format|
      if @buzz_source.update_attributes(params[:buzz_source])
        format.html { redirect_to @buzz_source, notice: 'Buzz source was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @buzz_source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buzz_sources/1
  # DELETE /buzz_sources/1.json
  def destroy
    @buzz_source = BuzzSource.find(params[:id])
    @buzz_source.destroy

    respond_to do |format|
      format.html { redirect_to buzz_sources_url }
      format.json { head :no_content }
    end
  end
end
