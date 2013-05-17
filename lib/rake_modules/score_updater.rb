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
      total_score = BuzzMention.where(:restaurant_id => restaurant.id, :ignore => false).sum("decayed_buzz_score")
      restaurant.total_current_buzz = total_score
      BuzzScore.create({ :restaurant_id => restaurant.id, :buzz_score => total_score})
      restaurant.save
      counter = counter -1
      print "\r#{counter} to go..."
    end
    puts "...and done!"
  end

  end
end
