
class UserController < ApplicationController

  #layout "site"
  #include ApplicationHelper

  #before_filter :protect, :only => :index
  before_filter :protect, :except => [ :login, :register ]

  def index

    @title = "Main Page"

  end

  def profile

    @title = "Profile page"

  end

  def register
    @title = "Registration"
    if param_posted?(:user)

      #logger.info params[:user].inspect
      #raise params[:user].inspect
      
      @user = User.new(params[:user])
      
      if @user.save
        #render :text => "User Created"
        @user.login!(session)
        session[:user_id] = @user.id
        flash[:notice] = "User " + @user.screen_name + " created"
        redirect_to_forwarding_url
      else
        @user.clear_password!
      end
    end
  end

  def login
    @title = "Login Page"
    if request.get?
      @user = User.new( :remember_me => remember_me_value)

    elsif param_posted?(:user)

      @user = User.new(params[:user])
      user = User.find_by_screen_name(@user.screen_name)

      if user and user.password_confirm?(@user.password)

        user.login!(session)

        @user.remember_me? ? user.remember!(cookies) : user.forget!(cookies)
        
        flash[:notice] = "User " + @user.screen_name + " logged in."
        redirect_to_forwarding_url
      else
        @user.clear_password!
        flash[:notice] = "Invalid screen name/password combination."
      end
    end
  end

  def logout
    User.logout!(session,cookies)
    flash[:notice] = "Logged out"
    redirect_to :controller => "site", :action => "index"
  end

  private

  #redirecting in case not logged in
  def protect
    unless logged_in?
      session[:protected_page] = request.request_uri
      flash[:notice] = "Please log in first"
      redirect_to :action => "login"
      return false
    end
  end

  #return true if the parameters to given symbol are posted
  def param_posted?(symbol)
    request.post? and params[symbol]
  end

  #redirecting to Url if it is setted
  def redirect_to_forwarding_url
    if (redirect_url = session[:protected_page])
      session[:protected_page] = nil
      redirect_to redirect_url
    else
      redirect_to :action => "index"
    end
  end

  #function to return the string value of remember me status
  def remember_me_value
    cookies[:remember_me] || "0"
  end
  
end
