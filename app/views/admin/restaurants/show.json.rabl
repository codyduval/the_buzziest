object @restaurant

attributes :id, :name, :twitter_handle, :total_current_buzz, 
           :buzz_mention_count_ignored, :created_at, :updated_at, :city

node do |restaurant|
  {
    :created_at_formatted => restaurant.created_at.strftime("%m/%d/%Y"),
    :total_current_buzz_rounded => 
      number_with_precision(restaurant.total_current_buzz,:precision => 1)
  }
end
