module City

  def self.short_name(city)
    city = city.to_sym if city.class == String
    city = @cities[city]
    if (city == nil)
      raise StandardError, "No such city"
    else
      return city;
    end
  end

  def self.all_names
    cities_array = []
    @cities.each_value {|value| cities_array.push(value) }
    return cities_array
  end

private
@cities = {
    :nyc => "nyc",
    :la => "la",
    :sf => "sf"
  }

end


