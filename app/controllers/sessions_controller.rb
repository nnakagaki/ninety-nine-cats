class SessionsController < ApplicationController

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(user_params)
    if user
      token = user.reset_session_token!
      session[:session_token] = token
      redirect_to cats_url
    else
      render :new
    end
  end

  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to cats_url
  end

  def logout
    destroy
  end

  private
  def user_params
    params[:user].permit(:user_name, :password)
  end
end
