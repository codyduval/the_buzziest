module RakeModules 
  module PostCleaner 

  def self.destroy_old_posts(old_posts_with_no_mentions)
    puts "Destroying ".light_red + posts_to_destroy.count.to_s.light_red + " posts".light_red
    BuzzPost.destroy(old_posts_with_no_mentions)
  end

  def self.destroy_old_buzz_mentions(buzz_mentions)
    puts "Destroying ".light_red + mentions_to_destroy.count.to_s.light_red + " mentions".light_red
    BuzzMention.destroy(buzz_mentions)
  end

  def self.update_counter_caches
    puts "Updating counter caches".light_red
    BuzzMention.counter_culture_fix_counts
  end


  end
end
