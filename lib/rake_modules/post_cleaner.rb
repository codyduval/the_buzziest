module RakeModules 
  module PostCleaner 

  def self.destroy_old_buzz_posts(buzz_posts)
    puts "Destroying ".light_red + buzz_posts.count.to_s.light_red + 
      " posts".light_red
    
    BuzzPost.destroy_old(buzz_posts)
  end

  def self.destroy_old_buzz_mentions(buzz_mentions)
    puts "Destroying ".light_red + buzz_mentions.count.to_s.light_red +
      " mentions".light_red
    BuzzMention.destroy_old(buzz_mentions)
  end 

  def self.update_counter_caches
    puts "Updating counter caches".light_red
    BuzzMention.counter_culture_fix_counts
  end

  def self.old_buzz_mentions_to_destroy
    tiny_score_mentions = BuzzMention.tiny_decayed_buzz_score
    ignored_and_old_mentions = BuzzMention.ignored_and_older_than(30)
    buzz_mentions = (tiny_score_mentions + ignored_and_old_mentions).uniq
  end

  def self.old_buzz_posts_to_destroy
    buzz_posts = BuzzPost.old_posts_no_mentions(30)
  end

  end
end
