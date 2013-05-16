require "minitest_helper"

describe User do
  it "creates a User factory" do
    user = FactoryGirl.build(:user)

    user.wont_be_nil 
  end

  it "creates a UserAdmin factory" do
    admin = FactoryGirl.build(:admin)

    admin.wont_be_nil 
  end

end

