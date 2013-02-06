class BuzzMention < ActiveRecord::Base
  attr_accessible :buzz_post, :buzz_score, :restaurant_name, :restaurant_id, :buzz_post_id, :decayed_buzz_score

  belongs_to :buzz_post
  belongs_to :restaurant, :counter_cache => true
  has_many :buzz_sources, :through => :buzz_posts

  def calculate_decayed_buzz_score(options = {})
      options = {:now=> Time.now, :buzz_points=>self.buzz_score, :date=>self.created_at }.merge(options)
      now = options[:now]
      buzz_points  = options[:buzz_points]
      date = options[:date]
      age_in_seconds = now - date
      age_in_days = age_in_seconds/86400
      decayed_buzz_score = buzz_points*((0.906)**age_in_days)
  end

end
