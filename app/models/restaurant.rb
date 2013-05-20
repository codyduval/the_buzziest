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
  
  def total_score 
    total_score = self.buzz_mentions.not_ignored.sum("decayed_buzz_score")    
  end

  def self.fuzzy_match(name)
    fuzzy_match = self.search do
      fulltext %Q/"#{name}"/
    end
    fuzzy_match = fuzzy_match.results
  end
  
end
