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
    elsif Vote.where(work_id: @work.id)
      Vote.where(work_id: @work.id).destroy_all
      @work.destroy
    else
      @work.destroy
    end

    flash[:success] = "Successfully deleted #{@work.category} #{@work.id}: \"#{@work.title}\""
    redirect_to root_path
    return
  end

  private

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end
end
