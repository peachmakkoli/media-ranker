class WorksController < ApplicationController
  def index
    # lists all works by order of votes, can be id for now
  end

  def show
    # find work by id
    # if nil, set head to :not_found, return
  end

  def new
    # work.new
  end

  def create
    # work.new pass in work_params
    # if save is successful
    # flash success message: "Successfully created work.category work.id work.title"
    # redirect to work_path, return
    # else if save is unsuccessful
    # flash error message: "A problem occurred: Could not create work.category"
    # flash errors
    # render :new, status :bad_request, return
  end

  def edit
    # find work by id
    # if nil, set head to :not_found
  end

  def update
    # find work by id
    # if nil, set head to :not_found, return
    # else if update is successful
    # flash success message: "Successfully updated work.category work.id work.title"
    # else if save is unsuccessful
    # flash error message: "A problem occurred: Could not create work.category"
    # flash errors
    # render :edit, status :bad_request, return
  end

  def destroy
    # find work by id
    # if nil, set head to :not_found, return
    # elsif the work has votes
    # destroy all votes first
    # then destroy work
    # else we can just destroy the work
    # flash success message: "Successfully deleted work.category work.id work.title"
    # redirect to root, return
  end

  private

  def work_params
    # permit category, title, creator, publication_year, description
  end
end
