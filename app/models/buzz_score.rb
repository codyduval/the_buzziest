class BuzzScore < ActiveRecord::Base
  attr_accessible :buzz_score, :restaurant_id

  belongs_to :restaurant
  
  after_create :update_restaurant_cache_value


  def update_restaurant_cache_value
    self.restaurant.total_current_buzz = self.buzz_score
    self.restaurant.save
  end

  def self.create_score_entry(restaurant)
      self.create(:restaurant_id => restaurant.id,
                  :buzz_score => restaurant.total_score)
  end 
end
