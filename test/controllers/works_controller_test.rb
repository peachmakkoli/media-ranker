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
  end

  describe "create" do
  end

  describe "edit" do
  end

  describe "update" do
  end

  describe "destroy" do
  end
end
