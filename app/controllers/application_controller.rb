class ApplicationController < ActionController::Base

  # protect_from_forgery with: :exception

  def current_user
    st = session[:session_token]
    return nil unless st
    @current_user ||= User.find_by(session_token: st)
  end


  helper_method :current_user

end
