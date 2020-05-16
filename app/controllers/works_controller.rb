class WorksController < ApplicationController
  def index
    # lists all works by order of votes, can be id for now
    @works = Work.order("id")
  end

  def show
    @work = Work.find_by(id: params[:id])
    head :not_found if !@work
    return
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)

    if @work.save
      flash[:success] = "Successfully created #{@work.category} #{@work.id}: \"#{@work.title}\""
      redirect_to work_path(@work) 
      return
    else
      flash.now[:error] = "A problem occurred: Could not create #{@work.category}."
      render :new, status: :bad_request
      return
    end
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
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end
end
