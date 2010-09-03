require "#{File.dirname(__FILE__)}/../test_helper"

class RememberMeTest < ActionController::IntegrationTest
 
  include ApplicationHelper
  fixtures :users

  def setup
    temp_user = users(:valid_user)
    temp_user[:password] = "goodpass"
    @user = temp_user
  end

  # remeber me test with browser closing
  def test_remember_me
    login_valid_user
    assert_response :redirect
    assert_redirected_to :controller => "user", :action => "index"

    browser_closing_simulation
    get "site/index"
    assert logged_in?
    assert_equal @user.id, session[:user_id]
  end

  # Test for changing user id during the session
  def test_user_id_change
    login_valid_user
    assert_response :redirect
    assert_redirected_to :controller => "user", :action => "index"

    puts session[:user_id]
    session[:user_id] = 42
    puts session[:user_id]

    get "site/index"
    puts session[:user_id]
    
    assert logged_in?
    assert_equal @user.id, session[:user_id]
  end

  private

  def login_valid_user
    post "user/login", :user => {
      :screen_name => @user.screen_name,
      :password => @user.password,
      :remember_me => "1"
    }
  end

  def browser_closing_simulation
    @request.session[:user_id] = nil
    @request.session[:screen_name] = nil
  end
end