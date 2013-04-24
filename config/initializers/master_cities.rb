module MasterCities

  def self.get_city(city)
    city = @cities[city]
    if (city == nil)
      raise "No such city"
    else
      return city;
    end
  end

  def self.get_all_city_names
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


