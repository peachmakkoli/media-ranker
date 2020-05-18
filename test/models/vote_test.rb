require "test_helper"

describe Vote do
  before do
    @work = works(:album)
    @user = users(:user1)

    @vote = Vote.create!(
      user_id: @user.id,
      work_id: @work.id
    )
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
  end  
end
