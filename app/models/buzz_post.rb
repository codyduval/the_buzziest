class BuzzPost < ActiveRecord::Base
  attr_accessible :post_title, :post_guid, :post_content, :post_date_time, :post_uri, :post_weight, :scanned_flag, :buzz_source_id

  belongs_to :buzz_source
  has_many :buzz_mentions, :dependent => :destroy
  has_many :restaurants, :through => :buzz_mentions

  include PgSearch
  pg_search_scope :search_by_post, :against => [:post_title, :post_content]

  def self.create_from_postmark(mitt)
    BuzzPost.create(
      :post_title => mitt.subject,
      :post_content => mitt.text_body,
      :post_guid => mitt.message_id
    )
  end

  def self.assign_buzz_source_id(city)
    matched_city = City.find_by_short_name(city)
    matched_city_id = matched_city[:id]
    matched_source_type = BuzzSourceType.find_by_source_type("email")
    matched_source_type_id = matched_source_type[:id]
    buzz_source = BuzzSource.find_by_city_id_and_buzz_source_type_id(matched_city_id, matched_source_type_id)
    buzz_source_id = buzz_source[:id]
  end


end

