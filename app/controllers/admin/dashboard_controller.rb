class Admin::DashboardController < ApplicationController
  def index
    @restaurants = Restaurant.scoped.order("total_current_buzz DESC").page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @restaurants }
    end
  end
end
