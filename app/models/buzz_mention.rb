class BuzzMention < ActiveRecord::Base
  attr_accessible :buzz_post, :buzz_score, :restaurant_name, :restaurant_id,
                  :buzz_post_id, :decayed_buzz_score, :ignore

  belongs_to :buzz_post
  belongs_to :restaurant

  has_many :buzz_sources, :through => :buzz_posts
  has_many :buzz_mention_highlights, :dependent => :destroy
  
  scope :not_ignored, where(:ignore => false)
  scope :ignored, where(:ignore => true)
  scope :tiny_decayed_buzz_score, where("decayed_buzz_score < ?", 0.05)  
  
  counter_culture :restaurant,
    :column_name => Proc.new {|model| (model.ignore == false) ?
      'buzz_mention_count_ignored' : nil }, :column_names => 
      { ["buzz_mentions.ignore = ?", false] => 'buzz_mention_count_ignored'}

  def update_decayed_buzz_score!
    born_on_date = self.buzz_post.post_date_time ||= self.created_at
    decay_factor = self.buzz_post.buzz_source.decay_factor.to_f ||= 0.906
    age_in_seconds = Time.now - born_on_date
    age_in_days = age_in_seconds/86400
    decayed_buzz_score = self.buzz_score*((decay_factor)**age_in_days)
    self.decayed_buzz_score = decayed_buzz_score
    self.save
  end

  def calculate_decayed_buzz_score 
    born_on_date = self.buzz_post.post_date_time ||= self.created_at
    decay_factor = self.buzz_post.buzz_source.decay_factor.to_f ||= 0.906
    age_in_seconds = Time.now - born_on_date
    age_in_days = age_in_seconds/86400
    decayed_buzz_score = self.buzz_score*((decay_factor)**age_in_days)
  end

  def self.older_than(age_in_days)
    where("created_at < :days", {:days => age_in_days.day.ago})
  end

  def self.ignored_and_older_than(age_in_days) 
    ignored_and_old = self.older_than(age_in_days).ignored
  end
end
