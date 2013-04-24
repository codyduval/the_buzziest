module RestaurantsHelper
  def latest_buzz(restaurant)
    buzz = BuzzScore.where(:restaurant_id => restaurant.id).last(:order => "id asc", :limit => 1)
    if buzz == nil
      latest_buzz_score = 0
    else
      latest_buzz_score = buzz.buzz_score
    end
    return latest_buzz_score
  end

end
