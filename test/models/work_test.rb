require "test_helper"

describe Work do
  before do
    @album = works(:album)
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

  end

  describe "validations" do
  
  end

  describe "sort works" do
    
  end

  describe "top ten" do
    
  end
end
