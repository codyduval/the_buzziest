collection @restaurants

attributes :id, :name, :twitter_handle, :total_current_buzz, 
           :buzz_mention_count_ignored, :created_at, :updated_at, :city

node do |restaurant|
  {
    :created_at_formatted => restaurant.created_at.strftime("%m/%d/%Y"),
    :age_in_days => number_with_precision(((Time.now - restaurant.created_at)/60/60/24), :precision => 0).to_i,
    :total_current_buzz_rounded => 
      number_with_precision(restaurant.total_current_buzz,:precision => 1).to_f
  }
end
