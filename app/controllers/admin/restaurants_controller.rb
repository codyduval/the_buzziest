module Admin
  class RestaurantsController < AdminController
    
    def index
      @restaurants = Restaurant.find(:all, :order=>"total_current_buzz DESC")
    end

  end
end
