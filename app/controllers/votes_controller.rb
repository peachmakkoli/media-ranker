class VotesController < ApplicationController
  before_action do
    find_work(params[:work_id])
  end
  before_action :require_login

  def create
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

  def vote_params
    return params.require(:vote).permit(:work_id, :user_id)
  end 
end
