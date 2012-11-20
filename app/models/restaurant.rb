class Restaurant < ActiveRecord::Base
  attr_accessible :description, :name, :neighborhood, :rank, :rank_previous, :reserve, :style, :weeks_on_list

  searchable do
    text :name
   end

   has_many :buzz_mentions, :dependent => :destroy
   has_many :buzz_posts, :through => :buzz_mentions
   belongs_to :city

end
