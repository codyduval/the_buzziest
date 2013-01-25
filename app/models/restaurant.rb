class Restaurant < ActiveRecord::Base
  attr_accessible :description, :name, :neighborhood, :twitter_handle, :reserve, :style, :skip_scan, :exact_match

  has_many :buzz_mentions, :dependent => :destroy
  has_many :buzz_posts, :through => :buzz_mentions

  include PgSearch
  pg_search_scope :search_by_restaurant_name, :against => :name

  def buzz_mentions_custom_path(restaurant)
    if restaurant.buzz_mentions.exists?
      restaurant.buzz_mentions
    else
      "doesnt"
    end
  end

end
