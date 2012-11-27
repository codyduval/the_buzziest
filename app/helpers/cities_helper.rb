module CitiesHelper

  def city_names
    City.all.collect{|a| a.name}
  end

end
