class Restaurant < ActiveRecord::Base
  attr_accessible :description, :name, :neighborhood, :twitter_handle, :reserve, :style, :skip_scan, :exact_match, :total_current_buzz, :city

  has_many :buzz_mentions, :dependent => :destroy
  has_many :buzz_posts, :through => :buzz_mentions
  has_many :buzz_scores, :dependent => :destroy

  validates :name, :uniqueness => true

  scope :with_buzz, where("buzz_mention_count_ignored > 0")
  scope :not_skipped, where(:skip_scan => false)
  
  searchable do
    text :name
  end
 
  def fetch_and_update_twitter_handle!
    twitter_client = Fetch::TwitterHandle::Client.new(self.name)
    twitter_client.fetch_and_parse
    self.twitter_handle = twitter_client.twitter_handle 
    self.save
  end

  def total_score 
    total_score = self.buzz_mentions.not_ignored.sum("decayed_buzz_score")    
  end

  
  def self.batch_create_from_remote(remote_source_client)
    names = remote_source_client.name_list
    names.each do |name|
      restaurant = Restaurant.where(:name => 
        name[:name]).first_or_create(:city => name[:city]) 
      if restaurant.twitter_handle == nil
        restaurant.fetch_and_update_twitter_handle!
      end
    end
  end

  private

  def self.fuzzy_match(name)
    fuzzy_match = self.search do
      fulltext %Q/"#{name}"/
    end
    fuzzy_match = fuzzy_match.results
  end
end
