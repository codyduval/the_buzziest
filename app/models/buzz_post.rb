class BuzzPost < ActiveRecord::Base
  attr_accessible :buzz_source_name, :post_content, :post_date_time, :post_uri, :post_weight, :scanned_flag

  belongs_to :buzz_post
  has_many :buzz_mentions
  has_many :restaurants, :through => :buzz_mentions

end
