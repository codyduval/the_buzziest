module RestaurantsHelper
  def latest_buzz(restaurant)
    buzz = BuzzScore.where(:restaurant_id => restaurant.id).last(:order => "id asc", :limit => 1)
    buzz.buzz_score
  end

end
