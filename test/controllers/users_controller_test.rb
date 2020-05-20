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
    it "can log in as an existing user successfully, create flash message, and redirect" do
      perform_login(@user)

      expect(flash[:success]).must_include "Successfully logged in as existing user #{@user.username}"

      must_redirect_to root_path
    end

    it "can log in as a new user successfully, create flash message, and redirect" do
      new_user = User.new(username: "new_user")
      
      expect {
        perform_login(new_user)
      }.must_differ "User.count", 1

      new_user = User.find_by(username: "new_user")

      expect(flash[:success]).must_include "Successfully created new user #{new_user.username} with ID #{new_user.id}"
      
      must_redirect_to root_path
    end

    it "does not log in if the form data violates user validations, creates a flash message, and responds with a 400 error" do
      invalid_user = User.new(username: nil)

      expect {
        perform_login(invalid_user)
      }.wont_differ "User.count"

      expect(flash[:error]).must_include "A problem occurred: Could not log in"

      must_respond_with :bad_request
    end
  end

  describe "logout" do

  end
end
