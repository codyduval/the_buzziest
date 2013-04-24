module RestaurantsHelper
  def latest_buzz(restaurant)
    buzz = BuzzScore.where(:restaurant_id => restaurant.id).last(:order => "id asc", :limit => 1)
    latest_buzz_score = buzz.buzz_score ||= 0
  end

end
