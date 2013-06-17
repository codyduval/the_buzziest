collection @buzz_mentions

attributes :id, :highlight_text, :created_at  

child :restaurant do
  attribute :name 
end

child :buzz_post do
  attributes :id, :post_title, :post_guid, :post_content, :post_date_time, 
             :post_uri, :post_weight, :scanned_flag, :buzz_source_id, :city
  child :buzz_source do
    attribute :name
  end
end

node do |buzz_mention|
  {
  :blurb_text => buzz_mention.highlight_text ||= buzz_mention.buzz_post.post_title,
  :created_at_formatted => buzz_mention.created_at.strftime("%A, %b %d %Y at %I:%M%P(%Z)")
  }
end
