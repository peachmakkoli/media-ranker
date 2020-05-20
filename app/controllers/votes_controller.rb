class VotesController < ApplicationController
  def create
    return if !validate_work || !validate_user

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
      flash[:vote_errors] = @vote.errors.map{ |column, message| "#{column.capitalize} #{message}" }
      redirect_to request.referrer
      return
    end
  end

  private 

  # helper method for checking if the work exists
  def validate_work
    @work = Work.find_by(id: params[:work_id])

    if !@work
      head :not_found
      return
    else
      return true
    end
  end

  # helper method for checking if the user is logged in
  def validate_user
    @current_user = User.find_by(id: session[:user_id])

    if !@current_user
      flash[:error] = "A problem occurred: You must log in to do that"
      redirect_to request.referrer
      return
    else
      return true
    end
  end

  def vote_params
    return params.require(:vote).permit(:work_id, :user_id)
  end 
end
