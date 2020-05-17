class WorksController < ApplicationController
  def index
    @albums = sort_works("album")
    @books = sort_works("book")
    @movies = sort_works("movie")
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
      flash.now[:error] = "A problem occurred: Could not create #{@work.category}"
      render :new, status: :bad_request
      return
    end
  end

  def edit
    @work = Work.find_by(id: params[:id])
    head :not_found if !@work
    return
  end

  def update
    @work = Work.find_by(id: params[:id])

    if !@work
      head :not_found
      return
    elsif @work.update(work_params)
      flash[:success] = "Successfully updated #{@work.category} #{@work.id}: \"#{@work.title}\""
      redirect_to work_path(@work)
      return
    else
      flash.now[:error] = "A problem occurred: Could not update #{@work.category}"
      render :edit, status: :bad_request
      return
    end
  end

  def destroy
    @work = Work.find_by(id: params[:id])

    if !@work
      head :not_found
      return
    elsif @work.votes
      @work.votes.destroy_all
    end

    @work.destroy
    flash[:success] = "Successfully deleted #{@work.category} #{@work.id}: \"#{@work.title}\""
    redirect_to root_path
    return
  end

  # helper method for sorting works by number of votes; I chose this design instead of creating a "votes" column in the works table, because there was a possibility that values in the votes column would not match up the actual number of votes belonging to the work
  def sort_works(category)
    return Work.where(category: category).sort_by { |work| work.votes.count }.reverse!
  end

  private

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end
end
