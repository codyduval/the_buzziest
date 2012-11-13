class BuzzMention < ActiveRecord::Base
  attr_accessible :buzz_post, :buzz_score, :restaurant_name

  belongs_to :buzz_post
  belongs_to :restaurant

end
