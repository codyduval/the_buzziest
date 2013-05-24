require "minitest_helper"

describe RakeModules::ScoreUpdater do

  describe "#self.decay_buzz_mention_scores" do
    before do
      @mention_not_ignored = FactoryGirl.create(:buzz_mention, ignore: false)
      @ignored = FactoryGirl.create(:buzz_mention, ignore: true)    
      @buzz_mentions = BuzzMention.not_ignored
    end

    it "decreases score for each valid BuzzMention " do
      RakeModules::ScoreUpdater.decay_buzz_mention_scores(@buzz_mentions)
      decayed_mentions = BuzzMention.not_ignored 

      decayed_mentions.each do |decayed_mention|
        decayed_mention[:decayed_buzz_score].to_f.must_be :<, 
          @mention_not_ignored[:buzz_score].to_f   
      end
    end

  end

  describe "#self.update_total_scores" do
    before do
      @restaurant = FactoryGirl.create(:restaurant)
      @restaurant_two = FactoryGirl.create(:restaurant)
      FactoryGirl.create(:buzz_mention, restaurant: @restaurant,
                         decayed_buzz_score: 4)
      FactoryGirl.create(:buzz_mention, restaurant: @restaurant,
                         decayed_buzz_score: 5.4)
      FactoryGirl.create(:buzz_mention, restaurant: @restaurant_two,
                         decayed_buzz_score: 6)
    end

    it "calculates and updates all scores for each restaurant" do
      RakeModules::ScoreUpdater.update_total_scores

      @restaurant.buzz_scores.last.buzz_score.to_f.must_equal 9.4
      @restaurant_two.buzz_scores.last.buzz_score.to_f.must_equal 6 
    end
  end
end
