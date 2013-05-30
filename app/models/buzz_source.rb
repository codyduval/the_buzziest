class BuzzSource < ActiveRecord::Base
  attr_accessible :buzz_weight, :name, :uri, :source_id_tag, :buzz_source_type_id,
                  :x_path_nodes, :city, :buzz_source_type, :decay_factor

  has_many :buzz_posts, :dependent => :destroy

  scope :all_twitter, where(:buzz_source_type => 'twitter')
  scope :all_feeds, where(:buzz_source_type => 'feed')
  
  def self.buzz_source_id_email_from(city)
    buzz_source = self.where("buzz_source_type = ? AND city = ?","email", city)
    buzz_source_id = buzz_source.first.id
  end
end
