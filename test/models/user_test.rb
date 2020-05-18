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

end
