module RakeModules
  module ScoreUpdater
    
  def self.decay_buzz_mention_scores(buzz_mentions)
    progress_bar = ProgressBar.create(:format =>"%C %t %e %b", 
                                     :title => "total mentions to decay...", 
                                     :total => buzz_mentions.count)
    buzz_mentions.each do |buzz_mention|
      buzz_mention.update_decayed_buzz_score!
      progress_bar.increment
    end
    puts "...and done!".light_green
  end

  def self.update_total_scores
    restaurants = Restaurant.with_buzz
    progress_bar = ProgressBar.create(:format =>"%C %t %e %b", 
                                     :title => "restaurant scores to update...", 
                                     :total => restaurants.count)
    restaurants.each do |restaurant|
      BuzzScore.create_score_entry(restaurant)
      progress_bar.increment
    end
    puts "...and done!".light_green
  end

  end
end
