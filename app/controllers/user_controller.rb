
require 'digest/sha1'

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
      @user = User.new( :remember_me => cookies[:remember_me] || "0")

    elsif param_posted?(:user)

      @user = User.new(params[:user])
      user = User.find_by_screen_name_and_password(@user.screen_name,@user.password)

      if user
       
        #session[:user_id] = user.id
        #session[:screen_name] = user.screen_name
        user.login!(session)
        
        if @user.remember_me == "1"
          cookies[:remember_me] = {
            :value => "1",
            :expires => 10.years.from_now
          }

          user.authorization_token = Digest::SHA2.hexdigest(
            "#{user.screen_name}:#{user.password}"
          )
          user.save!
          cookies[:authorization_token] = {
            :value => user.authorization_token,
            :expires => 10.years.from_now
          }
        else
          cookies.delete(:remember_me)
          cookies.delete(:authorization_token)
        end
        
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
ee
  #redirecting to Url if it is setted
  def redirect_to_forwarding_url
    if (redirect_url = session[:protected_page])
      session[:protected_page] = nil
      redirect_to redirect_url
    else
      redirect_to :action => "index"
    end
  end
  
end
