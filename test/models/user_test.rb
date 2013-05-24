require "minitest_helper"

describe User do
  describe "#new" do
    it "creates a User factory" do
      user = FactoryGirl.build(:user)

      user.wont_be_nil 
    end

    it "creates a UserAdmin factory" do
      admin = FactoryGirl.build(:admin)

      admin.wont_be_nil 
    end

    it "needs a password to create" do
      user = FactoryGirl.build(:user, password: nil)
      user.save.must_equal false
    end

    it "won't create user with dupliate email address" do
      user = FactoryGirl.create(:user, email: "bob@bob.com")
      user2 = FactoryGirl.build(:user, email: "bob@bob.com")

      user2.save.must_equal false
    end
  end
end

