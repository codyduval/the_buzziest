require "minitest_helper"

describe BuzzSourceType do
  describe "self", "#get_buzz_source_type(bt)" do
    it "should find the correct type" do
      BuzzSourceType.get_buzz_source_type(:feed).must_equal "feed"
    end

    it "should return error for non existant type" do
      proc {BuzzSourceType.get_buzz_source_type(:honey_bee)}.must_raise StandardError
    end
  end

  describe "self", "#get_all_buzz_source_types" do
    it "should return all types" do
      BuzzSourceType.get_all_buzz_source_types.must_include "restaurant_list"
      BuzzSourceType.get_all_buzz_source_types.must_include "feed"
      BuzzSourceType.get_all_buzz_source_types.must_include "html"
    end
  end
end
