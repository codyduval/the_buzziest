class City < ActiveRecord::Base
  attr_accessible :name

  has_many :buzz_posts, :dependent => :destroy
  has_many :restaurants, :dependent => :destroy
  has_many :buzz_sources

end
