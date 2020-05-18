require "test_helper"

describe Work do
  before do
    @album = works(:album)
    @album2 = works(:album2)
    @album3 = works(:album3)
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
    let (:new_album) {
      Work.new(
        category: "album",
        title: "new album title"
      )
    }

    it "must have a category" do
      new_album.category = nil

      expect(new_album.valid?).must_equal false
      expect(new_album.errors.messages).must_include :category
      expect(new_album.errors.messages[:category]).must_equal ["can't be blank", "is not included in the list"]
    end

    it "must have a title" do
      new_album.title = nil

      expect(new_album.valid?).must_equal false
      expect(new_album.errors.messages).must_include :title
      expect(new_album.errors.messages[:title]).must_equal ["can't be blank"]
    end

    it "only allows album, book, or movie for category" do
      new_album.category = "video game"

      expect(new_album.valid?).must_equal false
      expect(new_album.errors.messages).must_include :category
      expect(new_album.errors.messages[:category]).must_equal ["is not included in the list"]
    end

    it "will only allow titles that are unique (case insensitive)" do
      new_album.title = @album.title.upcase

      expect(new_album.valid?).must_equal false
      expect(new_album.errors.messages).must_include :title
      expect(new_album.errors.messages[:title]).must_equal ["has already been taken"]
    end

    it "will allow a title already in the database under a different category" do
      new_work = Work.new(category: "movie", title: @album.title)
      
      expect(new_album.valid?).must_equal true
      expect(new_album.errors.messages).must_be_empty
    end
  end

  describe "sort works" do
    before do
      @category = "album"
      # 1 vote for the first album
      vote_1 = Vote.create!(work_id: @album.id, user_id: @user1.id)
      # 3 votes for the second album
      vote_2 = Vote.create!(work_id: @album2.id, user_id: @user1.id)
      vote_3 = Vote.create!(work_id: @album2.id, user_id: @user2.id)
      vote_4 = Vote.create!(work_id: @album2.id, user_id: @user3.id)
      # 2 votes for the third album
      vote_5 = Vote.create!(work_id: @album3.id, user_id: @user1.id)
      vote_6 = Vote.create!(work_id: @album3.id, user_id: @user2.id)
    end

    it "sorts by vote count if there are many works in the database" do      
      expect(Work.sort_works(@category).first).must_equal @album2
      expect(Work.sort_works(@category).second).must_equal @album3
      expect(Work.sort_works(@category).third).must_equal @album
    end

    it "returns an empty array if there are no works in the database" do
      Vote.destroy_all
      Work.destroy_all

      expect(Work.sort_works(@category)).must_be_empty
    end

    it "throws an exception if the category is invalid" do
      category = "invalid"

      expect {
        Work.sort_works(category)
      }.must_raise ArgumentError
    end
  end

  describe "top ten" do
    before do
      @category = "album"
      # 1 vote for the first album
      vote_1 = Vote.create!(work_id: @album.id, user_id: @user1.id)
      # 3 votes for the second album
      vote_2 = Vote.create!(work_id: @album2.id, user_id: @user1.id)
      vote_3 = Vote.create!(work_id: @album2.id, user_id: @user2.id)
      vote_4 = Vote.create!(work_id: @album2.id, user_id: @user3.id)
      # 2 votes for the third album
      vote_5 = Vote.create!(work_id: @album3.id, user_id: @user1.id)
      vote_6 = Vote.create!(work_id: @album3.id, user_id: @user2.id)
    end

    it "sorts by vote count if there are many works in the database" do      
      expect(Work.top_ten(@category).first).must_equal @album2
      expect(Work.top_ten(@category).second).must_equal @album3
      expect(Work.top_ten(@category).third).must_equal @album
    end

    it "only returns the top 10 works in the category" do      
      expect(Work.top_ten(@category).count).must_equal 10
    end

    it "returns all works if there are less than 10 works in the database" do
      Vote.destroy_all
      Work.destroy_all
      Work.create!(category: "album", title: "the only work in the database")

      expect(Work.top_ten(@category).count).must_equal 1
    end

    it "returns an empty array if there are no works in the database" do
      Vote.destroy_all
      Work.destroy_all

      expect(Work.top_ten(@category)).must_be_empty
    end

    it "throws an exception if the category is invalid" do
      category = "invalid"

      expect {
        Work.top_ten(category)
      }.must_raise ArgumentError
    end
  end

  describe "spotlight" do
    before do
      @category = "album"
      # 1 vote for the first album
      vote_1 = Vote.create!(work_id: @album.id, user_id: @user1.id)
      # 3 votes for the second album
      vote_2 = Vote.create!(work_id: @album2.id, user_id: @user1.id)
      vote_3 = Vote.create!(work_id: @album2.id, user_id: @user2.id)
      vote_4 = Vote.create!(work_id: @album2.id, user_id: @user3.id)
      # 2 votes for the third album
      vote_5 = Vote.create!(work_id: @album3.id, user_id: @user1.id)
      vote_6 = Vote.create!(work_id: @album3.id, user_id: @user2.id)
    end

    it "finds the work that has the highest number of votes" do
      expect(Work.spotlight).must_equal @album2
    end

    it "returns nil if there are no votes but many works in the database" do
      Vote.destroy_all

      expect(Work.spotlight).must_be_nil
    end

    it "returns nil if there are no works in the database" do
      Vote.destroy_all
      Work.destroy_all

      expect(Work.spotlight).must_be_nil
    end

    it "returns nil if there are no works in the database" do
      Vote.destroy_all
      Work.destroy_all

      expect(Work.spotlight).must_be_nil
    end

    it "handles ties by returning the work that was last voted on" do
      # adds a vote to the third album, ties with second album
      vote_7 = Vote.create!(work_id: @album3.id, user_id: @user3.id)

      expect(Work.spotlight).must_equal @album3
    end
  end
end
