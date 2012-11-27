class Restaurant < ActiveRecord::Base
  attr_accessible :description, :name, :neighborhood, :twitter_handle, :reserve, :style, :skip_scan, :exact_match

  searchable do
    text :name
   end

   has_many :buzz_mentions, :dependent => :destroy
   has_many :buzz_posts, :through => :buzz_mentions
   belongs_to :city

end
