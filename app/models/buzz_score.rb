class BuzzScore < ActiveRecord::Base
  attr_accessible :buzz_score, :restaurant_id

  belongs_to :restaurant

end
