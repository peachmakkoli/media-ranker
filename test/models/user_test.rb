require "test_helper"

describe User do
  before do
    @album = works(:album)
    @album2 = works(:album2)
    @album3 = works(:album3)
    @user1 = users(:user1)
    @user2 = users(:user2)
    @user3 = users(:user3)
  end
  
  it "can be instantiated" do
    expect(@user1.valid?).must_equal true
  end

  it "will have the required fields" do
    expect(@user1).must_respond_to :username
  end

  describe "relationships" do
    it "can have many votes" do
      vote_1 = Vote.create!(work_id: @album.id, user_id: @user1.id)
      vote_2 = Vote.create!(work_id: @album2.id, user_id: @user1.id)
      vote_3 = Vote.create!(work_id: @album3.id, user_id: @user1.id)
      
      expect(@user1.votes.count).must_equal 3
      @user1.votes.each do |vote|
        expect(vote).must_be_instance_of Vote
      end
    end
  end

  describe "validations" do
    let (:new_user) {
      User.new(
        username: "new user"
      )
    }

    it "must have a username" do
      new_user.username = nil

      expect(new_user.valid?).must_equal false
      expect(new_user.errors.messages).must_include :username
      expect(new_user.errors.messages[:username]).must_equal ["can't be blank"]
    end

    it "will only allow usernames that are unique" do
      new_user.username = @user1.username

      expect(new_user.valid?).must_equal false
      expect(new_user.errors.messages).must_include :username
      expect(new_user.errors.messages[:username]).must_equal ["has already been taken"]
    end
  end

  describe "upvoted works" do
    it "will return all works that have been upvoted by the user" do
      vote_1 = Vote.create!(work_id: @album.id, user_id: @user1.id)
      vote_2 = Vote.create!(work_id: @album2.id, user_id: @user1.id)

      expect(@user1.upvoted_works).must_include @album
      expect(@user1.upvoted_works).must_include @album2
    end

    it "will return an empty array if the user has no votes" do
      expect(@user1.upvoted_works).must_be_empty
    end
  end
end
