class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  def current_user
    st = session[:session_token]
    return nil unless st
    @current_user ||= User.find_by(session_token: st)
  end

  def login_user!(user)
    session[:session_token] = user.reset_session_token!
  end

  def signed_in?
    !!current_user
  end

  def check_login
    redirect_to cats_url if signed_in?
  end

  def verify_user
    @cat = Cat.find(params[:id])
    redirect_to cat_url(@cat) unless current_cat_owner_logged_in?(@cat)
  end

  def current_cat_owner_logged_in?(cat)
    cat.user_id == current_user.id
  end

  helper_method :current_user, :current_cat_owner_logged_in?

end
