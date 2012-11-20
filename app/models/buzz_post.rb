class BuzzPost < ActiveRecord::Base
  attr_accessible :post_title, :post_guid, :post_content, :post_date_time, :post_uri, :post_weight, :scanned_flag, :buzz_source_id

  belongs_to :buzz_source
  has_many :buzz_mentions
  has_many :restaurants, :through => :buzz_mentions

  searchable do
    text :post_title, :post_content
  end

  def self.create_from_postmark(mitt)
    BuzzPost.create(
      :post_title => mitt.subject,
      :post_content => mitt.text_body,
      :post_guid => mitt.message_id
    )
  end

  def self.assign_buzz_source_id(city)
    if city == 'nyc'
      return "6"
    elsif city == 'la'
      return "7"
    else
      return "999"
    end
  end


end

