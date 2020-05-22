class WorksController < ApplicationController
  before_action :find_work, only: [:show, :edit, :update, :destroy]

  def index
    @albums = Work.sort_works("album")
    @books = Work.sort_works("book")
    @movies = Work.sort_works("movie")
  end

  def show
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
      flash.now[:error] = "A problem occurred: Could not create #{@work.category}"
      flash.now[:work_errors] = @work.errors.map{ |column, message| "#{column.capitalize} #{message}" }
      render :new, status: :bad_request
      return
    end
  end

  def edit
  end

  def update
    if @work.update(work_params)
      flash[:success] = "Successfully updated #{@work.category} #{@work.id}: \"#{@work.title}\""
      redirect_to work_path(@work)
      return
    else
      flash.now[:error] = "A problem occurred: Could not update #{@work.category}"
      flash.now[:work_errors] = @work.errors.map{ |column, message| "#{column.capitalize} #{message}" }
      render :edit, status: :bad_request
      return
    end
  end

  def destroy
    @work.destroy
    flash[:success] = "Successfully deleted #{@work.category} #{@work.id}: \"#{@work.title}\""
    redirect_to root_path
    return
  end

  private

  def find_work
    @work = Work.find_by(id: params[:id])
    head :not_found if !@work
    return
  end

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end
end
