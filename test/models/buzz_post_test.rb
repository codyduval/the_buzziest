require "minitest_helper"

describe BuzzPost do
  it "should create a new BuzzPost" do
    buzz_post = FactoryGirl.build(:buzz_post)
    
    buzz_post.wont_be_nil
  end
end
