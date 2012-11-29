class City < ActiveRecord::Base
  attr_accessible :name, :short_name

  has_many :buzz_posts, :dependent => :destroy
  has_many :restaurants, :dependent => :destroy
  has_many :buzz_sources

end
