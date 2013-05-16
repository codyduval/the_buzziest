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
    restaurants = Restaurant.where("buzz_mention_count_ignored > 0")
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

  def self.valid_buzz_mentions
    buzz_mentions = BuzzMention.where(:ignore => false)
  end

  end
end
