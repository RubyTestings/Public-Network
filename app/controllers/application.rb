# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  include ApplicationHelper

  before_filter :check_authorization

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_test_session_id'

  #return true if the parameters to given symbol are posted
  def param_posted?(symbol)
    request.post? and params[symbol]
  end

  #redirecting in case not logged in
  def protect
    unless logged_in?
      session[:protected_page] = request.request_uri
      flash[:notice] = "Please log in first"
      redirect_to :controller => "user", :action => "login"
      return false
    end
  end

  def check_authorization
    authorization_token = cookies[:authorization_token]
    if authorization_token and not logged_in?
      user = User.find_by_authorization_token(cookies[:authorization_token])
      user.login!(session) if user
    end
  end
end
