require "test_helper"

describe WorksController do
  it "must get index" do
    get works_index_url
    must_respond_with :success
  end

  it "must get show" do
    get works_show_url
    must_respond_with :success
  end

  it "must get new" do
    get works_new_url
    must_respond_with :success
  end

  it "must get create" do
    get works_create_url
    must_respond_with :success
  end

  it "must get edit" do
    get works_edit_url
    must_respond_with :success
  end

  it "must get update" do
    get works_update_url
    must_respond_with :success
  end

  it "must get destroy" do
    get works_destroy_url
    must_respond_with :success
  end

end
