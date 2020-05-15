require "test_helper"

describe VotesController do
  it "must get create" do
    get votes_create_url
    must_respond_with :success
  end

end
