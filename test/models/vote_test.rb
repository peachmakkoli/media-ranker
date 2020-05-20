require "test_helper"

describe Vote do
  before do
    @work = works(:album)
    @user = users(:user1)
    @vote = votes(:vote1)
  end
  
  it "can be instantiated" do
    expect(@vote.valid?).must_equal true
  end

  it "will have the required fields" do
    [:work_id, :user_id].each do |field|
      expect(@vote).must_respond_to field
    end
  end

  describe "relationships" do
    it "vote can link to only one user and work" do
      
      expect(@vote.user).must_be_instance_of User
      expect(@vote.work).must_be_instance_of Work
    end

    it "can set the user through #user" do
      @vote.user = @user
      expect(@vote.user_id).must_equal @user.id
    end

    it "can set the user through #user_id" do
      @vote.user_id = @user.id
      expect(@vote.user).must_equal @user
    end

    it "can set the work through #work" do
      @vote.work = @work
      expect(@vote.work_id).must_equal @work.id
    end

    it "can set the work through #work_id" do
      @vote.work_id = @work.id
      expect(@vote.work).must_equal @work
    end

    it "can update work #votes_count upon creation" do
      expect(@vote.work.votes_count).must_equal 1
    end
  end 
  
  describe "validations" do
    before do
      @user2 = users(:user2)

      @new_vote = Vote.new(
        user_id: @user2.id,
        work_id: @work.id
      )
    end

    it "must have a user_id" do
      @new_vote.user_id = nil

      expect(@new_vote.valid?).must_equal false
      expect(@new_vote.errors.messages).must_include :user_id
      expect(@new_vote.errors.messages[:user_id]).must_equal ["can't be blank"]
    end

    it "must have a work_id" do
      @new_vote.work_id = nil

      expect(@new_vote.valid?).must_equal false
      expect(@new_vote.errors.messages).must_include :work_id
      expect(@new_vote.errors.messages[:work_id]).must_equal ["can't be blank"]
    end

    it "will only allow the user to vote for a work once" do
      @new_vote.user_id = @user.id # see before block on lines 4-8

      expect(@new_vote.valid?).must_equal false
      expect(@new_vote.errors.messages).must_include :user
      expect(@new_vote.errors.messages[:user]).must_equal ["has already voted for this work"]
    end
  end
end
