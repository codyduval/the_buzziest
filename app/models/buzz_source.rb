class BuzzSource < ActiveRecord::Base
  attr_accessible :buzz_weight, :name, :uri, :city_id, :source_type, :source_id_tag

  has_many :buzz_posts, :dependent => :destroy
  belongs_to :city

  searchable do
    text :source_id_tag
  end
  
end
