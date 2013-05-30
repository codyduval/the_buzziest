require "minitest_helper"

describe City do
  describe "self", "#short_name(city)" do
    it "should lookup the correct city" do
      City.short_name("nyc").must_equal "nyc"
    end

    it "should return error for non existant city" do
      proc {City.short_name("chicago")}.must_raise StandardError
    end
  end

  describe "self", "#all_names" do
    it "should return all names" do
      City.all_names.must_include "nyc"
      City.all_names.must_include "la"
      City.all_names.must_include "sf"
    end
  end
end
