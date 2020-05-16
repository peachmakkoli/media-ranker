require "test_helper"

describe WorksController do
  describe "index" do
    it "responds with success when there are many works saved" do
      expect(Work.count).must_equal 3

      get works_path
      must_respond_with :success
    end

    it "responds with success when there are no works saved" do
      expect { 
        Work.destroy_all
      }.must_differ "Work.count", -3

      get works_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "responds with success when showing an existing valid work" do
      work = works(:album)
      
      get work_path(work.id)
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
          category: "movie",
          title: "new movie title",
          creator: "new movie artist",
          publication_year: "new movie year",
          description: "new movie description"
        },
      }

      expect {
        post works_path, params: work_hash
      }.must_differ "Work.count", 1
      
      new_work = work.find_by(name: work_hash[:work][:title])
      expect(new_work.category).must_equal work_hash[:work][:category]
      expect(new_work.title).must_equal work_hash[:work][:title]
      expect(new_work.creator).must_equal work_hash[:work][:creator]
      expect(new_work.publication_year).must_equal work_hash[:work][:publication_year]
      expect(new_work.description).must_equal work_hash[:work][:description]

      expect(flash[:success]).must_include "Successfully created #{work.category} #{work.id}"
      
      must_redirect_to work_path(new_work.id)
    end

    it "does not create a work if the form data violates work validations, creates a flash message, and responds with a 400 error" do
      invalid_work_hash = {
        work: {
          category: "movie"
        },
      }

      expect {
        post works_path, params: invalid_work_hash
      }.wont_differ "Work.count"

      expect(flash[:error]).must_include "A problem occurred: Could not create #{invalid_work_hash[:work][:category]}"

      must_respond_with :bad_request
    end
  end

  describe "edit" do
  end

  describe "update" do
  end

  describe "destroy" do
  end
end
