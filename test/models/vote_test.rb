require "test_helper"

describe Vote do
  before do
    @album = works(:album)
    @album2 = works(:album2)
    @album3 = works(:album3)
    @user1 = users(:user1)
    @user2 = users(:user2)
    @user3 = users(:user3)

    @vote = Vote.create(
      work_id: @album.id,
      user_id: @user1.id
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
end
