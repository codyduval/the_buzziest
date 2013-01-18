class BuzzMention < ActiveRecord::Base
  attr_accessible :buzz_post, :buzz_score, :restaurant_name, :restaurant_id, :buzz_post_id

  belongs_to :buzz_post
  belongs_to :restaurant, :counter_cache => true
  has_many :buzz_sources, :through => :buzz_posts

end
