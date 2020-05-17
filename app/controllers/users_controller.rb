class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    head :not_found if !@user
    return
  end

  def login_form
    @user = User.new
  end

  def login
    user = User.find_by(user_params)

    if user
      session[:user_id] = user.id
      flash[:success] = "Successfully logged in as returning user #{username}"
    else
      user = User.create(user_params)
      session[:user_id] = user.id
      flash[:success] = "Successfully logged in as new user #{username}"
    end
  
    redirect_to root_path
    return
  end

  def current
    @current_user = User.find_by(id: session[:user_id])

    unless @current_user
      flash[:error] = "A problem occurred: You must log in to do that"
      redirect_to root_path
      return
    end
  end

  def logout
    session[:user_id] = nil
    flash[:success] = "Successfully logged out"
    redirect_to root_path
    return
  end

  private

  def user_params
    return params.require(:user).permit(:username)
  end
end
