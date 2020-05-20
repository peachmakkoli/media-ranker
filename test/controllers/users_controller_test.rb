require "test_helper"

describe UsersController do
  before do
    @user = users(:user1)
  end

  describe "index" do
    it "responds with success when there are many users saved" do
      expect(User.count).must_equal 3

      get users_path
      must_respond_with :success
    end

    it "responds with success when there are no users saved" do
      expect { 
        User.destroy_all
      }.must_differ "User.count", -3

      get users_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing valid user" do
      get user_path(@user.id)
      must_respond_with :success
    end

    it "responds with 404 with an invalid user id" do
      get user_path(-1)
      must_respond_with :not_found
    end
  end

  describe "login form" do
    it "responds with success" do
      get login_path
      must_respond_with :success
    end
  end
  
  describe "login" do
  
  end

  describe "logout" do

  end
end
