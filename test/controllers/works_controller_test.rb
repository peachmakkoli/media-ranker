require "test_helper"

describe WorksController do
  before do
    @work = works(:album)
  end

  describe "index" do
    it "responds with success when there are many works saved" do
      expect(Work.count).must_equal 11

      get works_path
      must_respond_with :success
    end

    it "responds with success when there are no works saved" do
      expect { 
        Work.destroy_all
      }.must_differ "Work.count", -11

      get works_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing valid work" do
      get work_path(@work.id)
      must_respond_with :success
    end

    it "responds with 404 with an invalid work id" do
      get work_path(-1)
      must_respond_with :not_found
    end
  end

  describe "new" do
    it "responds with success" do
      get new_work_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new work with valid information accurately, create flash message, and redirect" do
      work_hash = {
        work: {
          category: "album",
          title: "new album title",
          creator: "new album artist",
          publication_year: 2020,
          description: "new album description"
        },
      }

      expect {
        post works_path, params: work_hash
      }.must_differ "Work.count", 1
      
      new_work = Work.find_by(title: work_hash[:work][:title])
      expect(new_work.category).must_equal work_hash[:work][:category]
      expect(new_work.title).must_equal work_hash[:work][:title]
      expect(new_work.creator).must_equal work_hash[:work][:creator]
      expect(new_work.publication_year).must_equal work_hash[:work][:publication_year]
      expect(new_work.description).must_equal work_hash[:work][:description]

      expect(flash[:success]).must_include "Successfully created #{new_work.category} #{new_work.id}"
      
      must_redirect_to work_path(new_work.id)
    end

    it "does not create a work if the form data violates work validations, creates a flash message, and responds with a 400 error" do
      invalid_work_hash = {
        work: {
          category: "album",
          title: nil
        },
      }

      expect {
        post works_path, params: invalid_work_hash
      }.wont_differ "Work.count"

      expect(flash[:error]).must_include "A problem occurred: Could not create #{invalid_work_hash[:work][:category]}"
      expect(flash[:work_errors].first).must_equal "Title can't be blank"

      must_respond_with :bad_request
    end
  end

  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid work" do
      get edit_work_path(@work.id)
      must_respond_with :success
    end

    it "responds with a 400 error when getting the edit page for a non-existing work" do
      get edit_work_path(-1)
      must_respond_with :not_found
    end
  end

  describe "update" do
    let (:edited_work_hash) {
      {
        work: {
          category: "album",
          title: "edited album title",
          creator: "edited album artist",
          publication_year: 2019,
          description: "edited album description"          
        },
      }
    }

    it "can update an existing work with valid information accurately, create a flash message, and redirect" do
      expect {
        patch work_path(@work.id), params: edited_work_hash
      }.wont_differ "Work.count"

      @work.reload
      expect(@work.title).must_equal edited_work_hash[:work][:title]
      expect(@work.creator).must_equal edited_work_hash[:work][:creator]
      expect(@work.publication_year).must_equal edited_work_hash[:work][:publication_year]
      expect(@work.description).must_equal edited_work_hash[:work][:description]

      expect(flash[:success]).must_include "Successfully updated #{@work.category} #{@work.id}"

      must_redirect_to work_path(@work.id)
    end

    it "does not update any work if given an invalid id, and responds with a 404" do
      id = -1

      expect {
        patch work_path(id), params: edited_work_hash
      }.wont_differ "Work.count"

      must_respond_with :not_found
    end

    it "does not update a work if the form data violates work validations, creates a flash message, and responds with a 400 error" do
      invalid_work_hash = {
        work: {
          category: "album",
          title: nil
        },
      }

      expect {
        patch work_path(@work.id), params: invalid_work_hash
      }.wont_differ "Work.count"
      
      expect(flash[:error]).must_include "A problem occurred: Could not update #{@work.category}"
      expect(flash[:work_errors].first).must_equal "Title can't be blank"

      must_respond_with :bad_request
    end
  end

  describe "destroy" do
    it "destroys the work instance in db when work exists and has no votes, creates a flash message, then redirects" do
      expect{
        delete work_path(@work.id)
      }.must_differ "Work.count", -1

      expect(flash[:success]).must_include "Successfully deleted #{@work.category} #{@work.id}"

      must_redirect_to root_path
    end

    it "destroys the work instance in db when work exists and has at least one vote, creates a flash message, then redirects" do
      expect {
        delete work_path(@work.id)
      }.must_differ "Work.count", -1

      must_redirect_to root_path
    end

    it "does not change the db when the work does not exist, then responds with a 404 error" do
      expect{
        delete work_path(-1)
      }.wont_differ "Work.count"

      must_respond_with :not_found
    end
  end
end
