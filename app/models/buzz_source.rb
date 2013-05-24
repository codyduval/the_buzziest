class BuzzSource < ActiveRecord::Base
  attr_accessible :buzz_weight, :name, :uri, :source_id_tag, :buzz_source_type_id,
                  :x_path_nodes, :city, :buzz_source_type, :decay_factor

  has_many :buzz_posts, :dependent => :destroy
  
end
