require "minitest_helper"
require "#{Rails.root}/lib/rake_modules/score_updater.rb"

describe RakeModules::ScoreUpdater do
  it "gets all BuzzMentions where ignore is false" do
    buzz_mention_ignored = FactoryGirl.create(:buzz_mention, ignore: true)    
    buzz_mention_not_ignored = FactoryGirl.create(:buzz_mention, ignore: false)
    buzz_mention_not_ignored_two = FactoryGirl.create(:buzz_mention, ignore: false)

    buzz_mentions = RakeModules::ScoreUpdater.valid_buzz_mentions
    buzz_mentions.wont_include(buzz_mention_ignored)
    buzz_mentions.must_include(buzz_mention_not_ignored)
    buzz_mentions.must_include(buzz_mention_not_ignored_two)
  end

  it "decreases score for each BuzzMention " do
    buzz_mention_ignored = FactoryGirl.create(:buzz_mention, buzz_score: 2, ignore: true)    
    buzz_mention_not_ignored = FactoryGirl.create(:buzz_mention, buzz_score: 2, ignore: false)
    buzz_mention_not_ignored_two = FactoryGirl.create(:buzz_mention, buzz_score: 2, ignore: false)
    buzz_mentions = RakeModules::ScoreUpdater.valid_buzz_mentions
    
    RakeModules::ScoreUpdater.decay_buzz_mention_scores(buzz_mentions)
    decayed_mentions = RakeModules::ScoreUpdater.valid_buzz_mentions
    single_mention = decayed_mentions.first
    single_mention[:decayed_buzz_score].must_be :<, buzz_mention_ignored[:buzz_score]   
  end

end
