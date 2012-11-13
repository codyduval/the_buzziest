class BuzzSource < ActiveRecord::Base
  attr_accessible :buzz_weight, :name, :uri

  has_many :buzz_posts, :dependent => :destroy
  
end
