require "test_helper"

describe VotesController do
  before do
    @user = users(:user1)
    @work = works(:album11)
  end

  describe "create" do
    it "ensures a logged-in user can vote for a work they haven't already voted for, creates a flash message, and redirects" do
      perform_login(@user)
      work_id = @work.id

      expect {
        post work_upvote_path(work_id), params: {}, headers: { 'HTTP_REFERER' => 'http://example.com' } # reference: Lucas Caton, https://stackoverflow.com/a/56911587
      }.must_differ "Vote.count", 1

      vote = Vote.find_by(user: @user, work: @work)
      expect(vote.user_id).must_equal session[:user_id]
      expect(vote.work_id).must_equal work_id

      expect(flash[:success]).must_include "Successfully upvoted!"

      must_redirect_to request.referrer
    end

    it "ensures a logged-in user cannot vote for a work they have previously voted for, creates a flash message, and redirects" do
      perform_login(@user)
      upvoted_work_id = works(:album).id

      expect {
        post work_upvote_path(upvoted_work_id), params: {}, headers: { 'HTTP_REFERER' => 'http://example.com' }
      }.wont_differ "Vote.count"

      expect(flash[:error]).must_equal "A problem occurred: Could not upvote"
      expect(flash[:vote_errors].first).must_equal "User has already voted for this work"

      must_redirect_to request.referrer
    end
  end

  describe "validate work" do
    
  end

  describe "validate user" do

  end
end
