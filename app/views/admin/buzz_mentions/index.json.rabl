collection @buzz_mentions

attributes :id, :buzz_post_id, :restaurant_id, :created_at  

child :restaurant do
  attributes :id, :description, :name, :neighborhood, :twitter_handle, 
             :reserve, :style, :skip_scan, :exact_match, :total_current_buzz,
             :city
end

child :buzz_post do
  attributes :id, :post_title, :post_guid, :post_content, :post_date_time, 
             :post_uri, :post_weight, :scanned_flag, :buzz_source_id, :city
end
