require "minitest_helper"

describe BuzzMention do
  it "creates a BuzzMention factory" do
    buzz_mention = FactoryGirl.build(:buzz_mention)

    buzz_mention.wont_be_nil 
  end
end

