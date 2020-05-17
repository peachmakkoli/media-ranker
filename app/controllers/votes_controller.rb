class VotesController < ApplicationController
  def create
    @work = Work.find_by(id: params[:work_id])
    @current_user = User.find_by(id: session[:user_id])

    if !@work
      head :not_found
      return
    elsif !@current_user
      flash[:error] = "A problem occurred: You must log in to do that"
      redirect_to request.referrer
      return
    end

    @vote = Vote.new(
      work_id: @work.id, 
      user_id: @current_user.id
    )
    
    if @vote.save
      flash[:success] = "Successfully upvoted!"
      redirect_to request.referrer
      return
    else
      flash[:error] = "A problem occurred: Could not upvote"
      redirect_to request.referrer
      return
    end
  end

  private

  def vote_params
    return params.require(:vote).permit(:work_id, :user_id)
  end 
end
