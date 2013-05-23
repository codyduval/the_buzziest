class Restaurant < ActiveRecord::Base
  attr_accessible :description, :name, :neighborhood, :twitter_handle, :reserve, :style, :skip_scan, :exact_match, :total_current_buzz, :city

  has_many :buzz_mentions, :dependent => :destroy
  has_many :buzz_posts, :through => :buzz_mentions
  has_many :buzz_scores, :dependent => :destroy

  validates :name, :uniqueness => true

  scope :with_buzz, where("buzz_mention_count_ignored > 0")

  searchable do
    text :name
  end
 
  def fetch_and_update_twitter_handle!
    twitter_client = Fetch::TwitterHandle::Client.new(self.name)
    twitter_client.fetch
    self.twitter_handle = twitter_client.valid_twitter_handle 
    if self.save
      puts twitter_client.valid_twitter_handle
    end
  end

  def total_score 
    total_score = self.buzz_mentions.not_ignored.sum("decayed_buzz_score")    
  end

  def self.fuzzy_match(name)
    fuzzy_match = self.search do
      fulltext %Q/"#{name}"/
    end
    fuzzy_match = fuzzy_match.results
  end
  
  def self.batch_create_from_remote(name_list)
    name_list.each do |name|
      restaurant = Restaurant.where(:name => 
        name[:name]).first_or_create(:city => name[:city]) 
      if restaurant.twitter_handle == nil
        puts "Attempting to get Twitter handle for #{restaurant.name}...".cyan
        restaurant.fetch_and_update_twitter_handle!
      end
    end
  end
end
