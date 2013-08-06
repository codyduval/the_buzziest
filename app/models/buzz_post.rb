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
    if feed
      feed.entries.compact.each do |entry|
        if entry.published
          entry_published = entry.published
        else
          entry_published = Time.now
          puts "WARNING: Couldn't parse date, so assigning today as publish date"
        end
        unless BuzzPost.exists?(:post_guid => entry.id) || 
                               (entry_published < 25.day.ago)
          content = entry.content ||= entry.summary 
          sanitized_content = Sanitize.clean(content)
          BuzzPost.create(
            :buzz_source_id => source[:id],
            :post_title => entry.title,
            :post_content => sanitized_content,
            :post_uri => entry.url,
            :post_date_time => entry_published,
            :post_guid => entry.id ||= entry.url,
            :post_weight => source[:buzz_weight],
            :city => source[:city]
          )
        end
      end
    end
  end
  
  def self.create_from_twitter(timeline, source)
    timeline.each do |tweet|
      unless BuzzPost.exists?(:post_guid => tweet.id.to_s)
        BuzzPost.create(
          :post_guid => tweet.id.to_s,
          :buzz_source_id => source[:id],
          :post_content => tweet.text,
          :post_title => tweet.text,
          :post_uri => 
              "https://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id}",
          :post_date_time => tweet.created_at,
          :post_weight => source[:buzz_weight],
          :scanned_flag => false,
          :city => source[:city]
        )
      end
    end
  end
  
  def self.destroy_old(buzz_posts)
    progress_bar = ProgressBar.create(:format =>"%e %b", 
                                      :total => buzz_posts.count)
    buzz_posts.each do |buzz_post|
      buzz_post.destroy
      progress_bar.increment
    end
  end

  def self.old_posts(age_in_days)
    where("post_date_time < :days", {:days => age_in_days.day.ago})
  end

  def self.old_posts_no_mentions(age_in_days) 
    old_posts_no_mentions = self.old_posts(age_in_days).with_no_buzz_mentions
  end

  def self.paginated_for_index(posts_per_page, current_page)
    paginate(:per_page => posts_per_page, :page => current_page, :order => 'title')
  end

  def self.search_for_mentions(restaurants)
    all_hits = []
    progress_bar = ProgressBar.create(:format =>"%C %t %e %b", 
                                      :title => "restaurants to scan...", 
                                      :total => restaurants.count)
    restaurants.each do |restaurant|
      hits = self.search_for_mention_of(restaurant)
      all_hits << hits unless hits.empty?
      progress_bar.increment 
    end
    all_hits.flatten!
  end  

  private

  def self.filter_words_as_array(restaurant)
    if restaurant.filter_words
      filter_words = restaurant.filter_words.split(',')
      filter_words.collect! do |word|
        word.lstrip!
        word.rstrip!
        word = %Q/"#{word}"/ 
      end
    else
      return []
    end
  end

  def self.all_words_to_search(restaurant)
    exact_name = [%Q/"#{restaurant.name}"/] 
    filter_words = filter_words_as_array(restaurant)
    word_array = exact_name + filter_words
  end

  def self.search_string(word_array)
    word_array.reject!(&:empty?) 
    search_for_string = word_array.join(' ')
  end

  def self.search_for_mention_of(restaurant)
    hits = []
    search_words = all_words_to_search(restaurant)
    search_string = search_string(search_words)
    buzz_post_search_results = self.search do
      with(:city, restaurant.city)
      fulltext search_string do
        minimum_match search_words.count
        highlight :post_content
      end
    # buzz_post_search_results = self.search do
    #   with(:city, restaurant.city)
    #   fulltext %Q/"#{restaurant.name}"/ do
    #     highlight :post_content
    #   end
    end
    buzz_post_search_results.hits.each do |hit|
      search_hit = {}
      highlight = hit.highlights(:post_content).first
      if highlight.nil?
        highlight_text = "n/a"
      else
        highlight_text = highlight.format
      end
      search_hit[:buzz_post_id] = hit.primary_key.to_i
      search_hit[:highlight] =  highlight_text
      search_hit[:restaurant_id] = restaurant.id 
      hits << search_hit 
    end
    hits
  end
end

