class SessionsController < ApplicationController
  before_action :check_login

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(user_params)
    if user
      login_user!(user)
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

  private
  def user_params
    params[:user].permit(:user_name, :password)
  end
end
