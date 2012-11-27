module BuzzSourceTypesHelper

  def source_types
    BuzzSourceType.all.collect{|a| a.source_type}
  end

end
