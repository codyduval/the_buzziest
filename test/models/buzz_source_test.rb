require "minitest_helper"

describe BuzzSource do
  describe "#new" do
    it "creates a BuzzSource factory" do
      buzz_source = FactoryGirl.build(:buzz_source)
      
      buzz_source.wont_be_nil
    end
  end
end
