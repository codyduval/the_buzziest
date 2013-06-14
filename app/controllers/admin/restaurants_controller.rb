module Admin
  class RestaurantsController < AdminController
    
    def index
      @restaurants = Restaurant.all
    end

  end
end
