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
    @user = User.new(user_params)
    existing_user = User.find_by(user_params)

    if existing_user
      session[:user_id] = existing_user.id
      flash[:success] = "Successfully logged in as existing user #{existing_user.username}"
      redirect_to root_path
      return
    elsif @user.save
      session[:user_id] = @user.id
      flash[:success] = "Successfully created new user #{@user.username} with ID #{@user.id}"
      redirect_to root_path
      return
    else
      flash.now[:error] = "A problem occurred: Could not log in"
      flash.now[:user_errors] = @user.errors.map{ |column, message| "#{column.capitalize} #{message}" }
      render :login_form, status: :bad_request
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
