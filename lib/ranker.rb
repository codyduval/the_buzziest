# require 'activesupport'
module Ranker
  class BuzzDecay
    attr_accessor :date, :buzz_points, :now

    def initialize(options = {})
      self.date      = options[:date]
      self.buzz_points   = options[:buzz_points]
      self.now = options[:now]
    end

    def aged_buzz_score(options = {})
      options = {:now=> Time.now, :buzz_points=>@buzz_points, :date=>@date }.merge(options)
      now = options[:now]
      buzz_points  = options[:buzz_points]
      date = options[:date]
      age_in_seconds = now - date
      age_in_days = age_in_seconds/86400
      aged_buzz_score = buzz_points*((0.906)**age_in_days)
    end
  end

end