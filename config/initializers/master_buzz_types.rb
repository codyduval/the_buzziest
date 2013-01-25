module MasterBuzzSourceTypes

  def self.get_buzz_source_type(bt)
    buzz_source_type = @buzz_source_types[bt]
    if (buzz_source_type == nil)
      raise "No such buzz source type"
    else
      return buzz_source_type;
    end
  end

  def self.get_all_buzz_source_types
    buzz_source_types_array = []
    @buzz_source_types.each_value {|value| buzz_source_types_array.push(value) }
    return buzz_source_types_array
  end

private
@buzz_source_types = {
    :restaurant_list => "restaurant_list",
    :feed => "feed",
    :email => "email",
    :twitter => "twitter",
    :html => "html"
  }

end


