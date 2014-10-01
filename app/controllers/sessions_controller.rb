class SessionsController < ApplicationController

  before_action :check_login, except: :destroy

  def new
    render :new
  end

  def create
    user = User.find_by_credentials(user_params)
    if user
      login_user!(user)
      redirect_to cats_url
    else
      flash[:errors] = "Wrong user name and password combination"
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
    params.require(:user).permit(:user_name, :password)
  end

end
