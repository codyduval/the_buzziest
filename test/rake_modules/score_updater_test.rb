require "minitest_helper"
require "#{Rails.root}/lib/rake_modules/score_updater.rb"

describe RakeModules::ScoreUpdater do
  before do
    @buzz_mention_ignored = FactoryGirl.create(:buzz_mention, ignore: true)    
    @buzz_mention_not_ignored = FactoryGirl.create(:buzz_mention, ignore: false)
  end

  it "decreases score for each valid BuzzMention " do
    buzz_mention_not_ignored = FactoryGirl.create(:buzz_mention, ignore: true)
    buzz_mentions = BuzzMention.not_ignored

    RakeModules::ScoreUpdater.decay_buzz_mention_scores(buzz_mentions)
    decayed_mentions = BuzzMention.not_ignored 

    decayed_mentions.each do |decayed_mention|
      decayed_mention[:decayed_buzz_score].to_f.must_be :<, @buzz_mention_not_ignored[:buzz_score].to_f   
    end
  end

  it "does not decrease score for ignored BuzzMentions" do
    buzz_mentions = BuzzMention.not_ignored
    
    RakeModules::ScoreUpdater.decay_buzz_mention_scores(buzz_mentions)
    ignored_mentions = BuzzMention.where(:ignore => true) 
    single_mention = ignored_mentions.first

    single_mention[:decayed_buzz_score].to_f.must_equal @buzz_mention_ignored[:buzz_score].to_f   
  end

  it "#self.update_total_scores" do
    restaurant = FactoryGirl.create(:restaurant)
    restaurant_two = FactoryGirl.create(:restaurant)
    buzz_mention = FactoryGirl.create(:buzz_mention, :restaurant => restaurant)
    another_buzz_mention = FactoryGirl.create(:buzz_mention, :restaurant => restaurant_two)

    RakeModules::ScoreUpdater.update_total_scores

    buzz_score_entry = BuzzScore
  end
end
