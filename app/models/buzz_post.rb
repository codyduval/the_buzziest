class BuzzPost < ActiveRecord::Base
  attr_accessible :post_title, :post_guid, :post_content, :post_date_time, 
                  :post_uri, :post_weight, :scanned_flag, :buzz_source_id, :city

  belongs_to :buzz_source
  has_many :buzz_mentions, :dependent => :destroy
  has_many :restaurants, :through => :buzz_mentions

  scope :with_buzz_mentions, 
        where("id IN (SELECT DISTINCT(buzz_post_id) FROM buzz_mentions)")
  scope :with_no_buzz_mentions, 
        includes(:buzz_mentions).where(:buzz_mentions => {:buzz_post_id => nil})

  searchable do
    text :post_title, :stored => true
    text :post_content, :stored => true

    string :city
  end

  def self.create_from_postmark(mitt)
    sanitized_content = Sanitize.clean(mitt.text_body,
                                      Sanitize::Config::RESTRICTED)
    content_no_newline = sanitized_content.gsub(/\n/," ")
    BuzzPost.create(
      :post_title => mitt.subject,
      :post_content => content_no_newline,
      :post_guid => mitt.message_id,
      :buzz_source_id => 9999)
  end

  def self.create_from_feed(feed, source)
    feed.entries.each do |entry|
      unless BuzzPost.exists?(:post_guid => entry.id) || 
                             (entry.published < 25.day.ago)
        content = entry.content ||= entry.summary 
        sanitized_content = Sanitize.clean(content)
        BuzzPost.create(
          :buzz_source_id => source[:id],
          :post_title => entry.title,
          :post_content => sanitized_content,
          :post_uri => entry.url,
          :post_date_time => entry.published,
          :post_guid => entry.id ||= entry.url,
          :post_weight => source[:buzz_weight],
          :city => source[:city]
        )
      end
    end
  end

  
  def self.old_posts(age_in_days)
    where("post_date_time < :days", {:days => age_in_days.day.ago})
  end

  def self.old_posts_no_mentions(age_in_days) 
    old_posts_no_mentions = self.old_posts(age_in_days).with_no_buzz_mentions
  end

  def self.assign_buzz_source_id(type,city)
    buzz_source = BuzzSource.where("buzz_source_type = ? AND city = ?",type, city)
    buzz_source_id = buzz_source.first.id
  end

  def self.paginated_for_index(posts_per_page, current_page)
    paginate(:per_page => posts_per_page, :page => current_page, :order => 'title')
  end

end

