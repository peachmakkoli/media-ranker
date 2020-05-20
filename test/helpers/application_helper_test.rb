require "test_helper"

describe ApplicationHelper, :helper do
  describe "readable_date" do
    it "produces text in Month D, YYYY format" do
      date = Date.today
      result = readable_date(date)
      
      expect(result).must_include date.strftime("%B %e, %Y")
    end
    
    it "produces a tag with the full timestamp" do
      date = Date.today
      result = readable_date(date)

      expect(result).must_include date.to_s
    end

    it "returns [unknown] if the date is nil" do
      date = nil
      result = readable_date(date)

      expect(result).must_equal "[unknown]"
    end
  end
end