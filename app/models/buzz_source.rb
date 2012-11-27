class BuzzSource < ActiveRecord::Base
  attr_accessible :buzz_weight, :name, :uri, :city_name, :source_type, :source_id_tag, :buzz_source_type_id

  has_many :buzz_posts, :dependent => :destroy
  belongs_to :city
  belongs_to :buzz_source_type

  searchable do
    text :source_id_tag
  end

  def city_name
    self.city.name if self.city.present?
  end

  def city_name=(name)
    self.city = City.find_or_create_by_name name
  end

  def source_type
  	self.buzz_source_type.source_type if self.buzz_source_type.present?
  end

  def source_type=(source_type)
  	self.buzz_source_type = BuzzSourceType.find_or_create_by_source_type source_type
  end
  
end
