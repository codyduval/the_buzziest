module Admin
  class RestaurantsController < AdminController
    
    def index
      @restaurants = Restaurant.find(:all, :order=>"total_current_buzz DESC")
    end

    def show
      @restaurant = Restaurant.find params[:id]
    end

  end
end
