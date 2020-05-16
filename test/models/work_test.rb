require "test_helper"

describe Work do
  before do
    @album = works(:album)
    @user1 = users(:user1)
    @user2 = users(:user2)
    @user3 = users(:user3)
  end
  
  it "can be instantiated" do
    expect(@album.valid?).must_equal true
  end

  it "will have the required fields" do
    [:category, :title, :creator, :publication_year, :description].each do |field|
      expect(@album).must_respond_to field
    end
  end

  describe "relationships" do
    it "can have many votes" do
      vote_1 = Vote.create!(work_id: @album.id, user_id: @user1.id)
      vote_2 = Vote.create!(work_id: @album.id, user_id: @user2.id)
      vote_3 = Vote.create!(work_id: @album.id, user_id: @user3.id)
      
      expect(@album.votes.count).must_equal 3
      @album.votes.each do |vote|
        expect(vote).must_be_instance_of Vote
      end
    end
  end

  describe "validations" do
  
  end

  describe "sort works" do
    
  end

  describe "top ten" do
    
  end
end
