require "minitest_helper"
require "#{Rails.root}/lib/rake_modules/score_updater.rb"

describe RakeModules::ScoreUpdater do
  before do
    @buzz_mention_ignored = FactoryGirl.create(:buzz_mention, ignore: true)    
    @buzz_mention_not_ignored = FactoryGirl.create(:buzz_mention, ignore: false)
    @buzz_mention_not_ignored_two = FactoryGirl.create(:buzz_mention, ignore: false)
    @buzz_mentions = BuzzMention.not_ignored

  end

  it "gets all BuzzMentions where ignore is false" do
    @buzz_mentions.wont_include(@buzz_mention_ignored)
    @buzz_mentions.must_include(@buzz_mention_not_ignored)
    @buzz_mentions.must_include(@buzz_mention_not_ignored_two)
  end

  it "decreases score for each valid BuzzMention " do
    RakeModules::ScoreUpdater.decay_buzz_mention_scores(@buzz_mentions)
    decayed_mentions = BuzzMention.not_ignored 
    decayed_mentions.each do |single_mention|
      single_mention[:decayed_buzz_score].to_f.must_be :<, @buzz_mention_not_ignored[:buzz_score].to_f   
    end
  end

  it "does not decay ignored BuzzMentions" do
    RakeModules::ScoreUpdater.decay_buzz_mention_scores(@buzz_mentions)
    ignored_mentions = BuzzMention.where(:ignore => true) 
    single_mention = ignored_mentions.first
    single_mention[:decayed_buzz_score].to_f.must_equal @buzz_mention_ignored[:buzz_score].to_f   
  end

  it "does not get Restaurants with no buzz mentions" do
    restaurant_no_mentions = FactoryGirl.create(:restaurant)
    restaurants = Restaurant.with_buzz

    restaurants.wont_include(restaurant_no_mentions)
  end

  it "does get Restaurants with buzz mentions" do
    restaurant_with_buzz = @buzz_mention_not_ignored.restaurant 
    restaurants = Restaurant.with_buzz

    restaurants.must_include(restaurant_with_buzz)
  end
end
