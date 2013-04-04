class BuzzPost < ActiveRecord::Base
  attr_accessible :post_title, :post_guid, :post_content, :post_date_time, :post_uri, :post_weight, :scanned_flag, :buzz_source_id

  belongs_to :buzz_source
  has_many :buzz_mentions, :dependent => :destroy
  has_many :restaurants, :through => :buzz_mentions

  # include PgSearch

  # pg_search_scope :search_by_post, :against => [:post_title, :post_content],
                  # :using => {:tsearch => {:normalization => 4}}

  searchable do
    text :post_title, :stored => true
    text :post_content, :stored => true
  end

  def self.create_from_postmark(mitt)
    stripped_tags_email_body_content = ActionController::Base.helpers.strip_tags(mitt.text_body)
    stripped_email_body_content = ActionController::Base.helpers.strip_links(stripped_tags_email_body_content)
    # stripped_email_body_content= Sanitize.clean(mitt.text_body, Sanitize::Config::RESTRICTED)
    BuzzPost.create(
      :post_title => mitt.subject,
      :post_content => stripped_email_body_content,
      :post_guid => mitt.message_id
    )
  end

  def self.assign_buzz_source_id(type,city)
    buzz_source = BuzzSource.where("buzz_source_type = ? AND city = ?",type, city)
    buzz_source_id = buzz_source.first.id
  end

  def self.paginated_for_index(posts_per_page, current_page)
    paginate(:per_page => posts_per_page, :page => current_page, :order => 'title')
  end

end

