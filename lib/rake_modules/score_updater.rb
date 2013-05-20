module RakeModules
  module ScoreUpdater
    
  def self.decay_buzz_mention_scores(buzz_mentions)
    puts "Decaying scores"
    counter = buzz_mentions.count
    buzz_mentions.each do |buzz_mention|
      buzz_mention.update_decayed_buzz_score!
      counter = counter -1
      print "\r#{counter} to go..."
    end
    puts "...and done!"
  end

  def self.update_total_scores
    puts "Updating score table"
    restaurants = Restaurant.with_buzz
    counter = restaurants.count
    restaurants.each do |restaurant|
      BuzzScore.create_score_entry(restaurant)
      counter = counter -1
      print "\r#{counter} to go..."
    end
    puts "...and done!"
  end

  end
end
