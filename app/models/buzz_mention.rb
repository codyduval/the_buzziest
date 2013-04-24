class BuzzMention < ActiveRecord::Base
  attr_accessible :buzz_post, :buzz_score, :restaurant_name, :restaurant_id, :buzz_post_id, :decayed_buzz_score, :ignore

  belongs_to :buzz_post
  belongs_to :restaurant, :counter_cache => true
  has_many :buzz_sources, :through => :buzz_posts
  has_many :buzz_mention_highlights, :dependent => :destroy

  def calculate_decayed_buzz_score(options = {})
      options = {:now=> Time.now, :buzz_points=>self.buzz_score, :date=>self.buzz_post.post_date_time, :decay_factor=>self.buzz_post.buzz_source.decay_factor }.merge(options)
      now = options[:now]
      buzz_points  = options[:buzz_points]
      date = options[:date] ||= self.created_at
      decay_factor = options[:decay_factor].to_f
      age_in_seconds = now - date
      age_in_days = age_in_seconds/86400
      decayed_buzz_score = buzz_points*((decay_factor)**age_in_days)
  end

  def update_decayed_buzz_score!(options = {})
      options = {:now=> Time.now, :buzz_points=>self.buzz_score, :date=>self.buzz_post.post_date_time, :decay_factor=>self.buzz_post.buzz_source.decay_factor }.merge(options)
      now = options[:now]
      buzz_points  = options[:buzz_points]
      date = options[:date]
      decay_factor = options[:decay_factor].to_f
      age_in_seconds = now - date
      age_in_days = age_in_seconds/86400
      decayed_buzz_score = buzz_points*((decay_factor)**age_in_days)
      self.decayed_buzz_score = decayed_buzz_score
      self.save
  end

end
