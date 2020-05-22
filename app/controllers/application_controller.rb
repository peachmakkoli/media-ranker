class ApplicationController < ActionController::Base
  def find_work(id)
    @work = Work.find_by(id: id) 
    head :not_found if !@work
    return
  end
  
  def current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def require_login
    if !current_user
      flash[:error] = "A problem occurred: You must log in to do that"
      redirect_to request.referrer
      return
    end
  end
end
