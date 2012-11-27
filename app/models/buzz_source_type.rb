class BuzzSourceType < ActiveRecord::Base
  attr_accessible :source_type

  has_many :buzz_sources

end
