require File.dirname(__FILE__) + '/../test_helper'
require 'user_controller'

# Re-raise errors caught by the controller.
class UserController; def rescue_action(e) raise e end; end

class UserControllerTest < Test::Unit::TestCase
  include ApplicationHelper
  fixtures :users

  def setup
    @controller = UserController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @valid_user = users(:valid_user)
  end

  def test_screen_name_length_boundaries
    assert_length :min, @valid_user, :screen_name, User::SCREEN_NAME_MIN_LENGTH
    assert_length :max, @valid_user, :screen_name, User::SCREEN_NAME_MAX_LENGTH
  end

  def test_password_length_boundaries
    assert_length :min, @valid_user, :password, User::PASSWORD_MIN_LENGTH
    assert_length :max, @valid_user, :password, User::PASSWORD_MAX_LENGTH
  end

  # Replace this with your real tests.
  def test_registration_page
    get :register
    title = assigns(:title)
    assert_equal "Registration", title
    assert_response :success
    assert_template "register"

    assert_form_tag "/user/register"
    assert_screen_name_field
    assert_email_field
    assert_password_field
    assert_submit_button "Register!"
    
  end

  #make sure the login page works and all fields are correct
  def test_login_page
    get :login
    title = assigns(:title)

    assert_equal "Login Page", title
    assert_response :success
    assert_template "login"
    assert_form_tag "/user/login"
    assert_screen_name_field
    assert_password_field
    assert_tag "input", :attributes => { :name => "user[remember_me]",
                                         :type => "checkbox"
                                       }
    assert_submit_button "Login!"
  end

  def test_edit_page
    authorize @valid_user
    get :edit
    title = assigns(:title)
    assert_equal "Edit info", title
    assert_response :success
    assert_template "edit"

    assert_form_tag "/user/edit"
    assert_email_field @valid_user.email
    assert_password_field "current_password"
    assert_password_field
    assert_password_field "password_confirmation"
    assert_submit_button "Update"

  end

  def test_registration_success
    post :register, :user => {  :screen_name => "new_screen_name",
                                :email => "valid@mail.com",
                                :password => "SmaplePasswrd"
                             }
    user = assigns(:user)
    assert_not_nil user

    new_user = User.find_by_screen_name_and_password(user.screen_name,user.password)

    assert_equal new_user, user

    assert_equal "User #{new_user.screen_name} created", flash[:notice]
    assert_redirected_to :action => "index"

    assert  logged_in?
    assert_equal    user.id, session[:user_id]
  end

  def test_registration_failure

    wrong_user = { :screen_name => "aa/noyes",
                   :email => "t@ewes,qw",
                   :password => "tq"
                 }

   post :register, :user => wrong_user
   assert_response :success
   assert_template "register"

   assert_tag "div", :attributes => { :id => "errorExplanation",
                                      :class => "errorExplanation"
                                    }
   assert_tag "li", :content => /Screen name/
   assert_tag "li", :content => /Email/
   assert_tag "li", :content => /Password/

   error_div = { :tag => "div", :attributes => { :class => "fieldWithErrors"}}

   assert_tag "input", :attributes => { :name => "user[screen_name]",
                                        :value => wrong_user[:screen_name]
                                      },
                       :parent => error_div
   assert_tag "input", :attributes => { :name => "user[email]",
                                        :value => wrong_user[:email]
                                      },
                       :parent => error_div
   assert_tag "input", :attributes => { :name => "user[password]",
                                        :value => nil
                                      },
                       :parent => error_div
  end
  
  #test valid login
  def test_login_success
    try_to_login @valid_user, :remember_me => "0"

    assert  logged_in?
    assert_equal @valid_user.id, session[:user_id]
    assert_equal "User #{@valid_user.screen_name} logged in.", flash[:notice]
    assert_response :redirect
    assert_redirected_to :action => "index"

    #user is not remembered
    user = assigns(:user)
    assert user.remember_me != "1"
    assert_nil cookie_value(:remember_me)
    assert_nil cookie_value(:authorization_token)
  end

    #test valid login
  def test_login_success_with_remember_me
    try_to_login @valid_user, :remember_me => "1"
    test_time = Time.now

    assert  logged_in?
    assert_equal @valid_user.id, session[:user_id]
    assert_equal "User #{@valid_user.screen_name} logged in.", flash[:notice]
    assert_response :redirect
    assert_redirected_to :action => "index"

    #check cookies and expiration dates
    user = User.find(@valid_user.id)

    assert_equal "1", cookie_value(:remember_me)
    
    #assert_equal User::COOKIES_EXPIRATION_TIME.years.from_now(test_time).to_s,
    #             cookie_expires(:remember_me).to_s
    time_delta = 10000
    assert_in_delta User::COOKIES_EXPIRATION_TIME.years.from_now(test_time),
                    cookie_expires(:remember_me),
                    time_delta
    
    #Authorization cookie
    #cookie_token = cookies["authorization_token"].value.to_s
    assert_equal user.authorization_token, cookie_value(:authorization_token)

    #assert_equal User::COOKIES_EXPIRATION_TIME.years.from_now(test_time).to_s,
    #             cookie_expires(:authorization_token).to_s
    assert_in_delta User::COOKIES_EXPIRATION_TIME.years.from_now(test_time),
                    cookie_expires(:authorization_token),
                    time_delta
  end
  
  #test invalid login
  def test_login_failure_with_nonexistent_screen_name
    invalid_user = @valid_user
    invalid_user.screen_name = "no such user"
    try_to_login invalid_user
    assert_template "login"
    assert_equal "Invalid screen name/password combination.", flash[:notice]
    user = assigns(:user)
    assert_equal invalid_user.screen_name, user.screen_name
    assert_nil user.password
  end

  def test_login_failure_with_wrong_password
    invalid_user = @valid_user
    invalid_user.password += "nor"
    try_to_login invalid_user
    assert_template "login"
    assert_equal "Invalid screen name/password combination.", flash[:notice]
    user = assigns(:user)
    assert_equal invalid_user.screen_name, user.screen_name
    assert_nil user.password
  end

  def test_logout
    try_to_login @valid_user, :remember_me => "1"
    assert logged_in?
    assert_not_nil cookie_value(:authorization_token)
    get :logout
    assert_response :redirect
    assert_redirected_to :controller => "site", :action => "index"
    assert_equal "Logged out", flash[:notice]
    assert  !logged_in?
    assert_nil cookie_value(:authorization_token)
  end

  #test navigation menu after login
  def test_navigation_logged_in
    authorize @valid_user
    get :index
    assert_tag "a", :content => /Logout/,
                    :attributes => { :href => "/user/logout"}
    assert_no_tag "a", :content => /Register/
    assert_no_tag "a", :content => /Login/
  end

  #test index page for unauthorized user
  def test_index_unauthorized
    get :index
    assert_response :redirect
    assert_redirected_to :action => "login"
    assert_equal "Please log in first", flash[:notice]
  end

  #test index for authorized user
  def test_index_authorized
    authorize @valid_user
    get :index
    assert_response :success
    assert_template "index"
  end

  #test forward back to protected page after login
  def test_login_friendly_url_forwarding
    user = { :screen_name => @valid_user.screen_name,
             :remember_me => "0",
             :password => @valid_user.password
           }
    friendly_url_forwarding_aux(:login, :profile, user)
  end

  #test forward back to protected page after registration
  def test_register_friendly_url_forwarding
    user = { :screen_name => @valid_user.screen_name,
             :email => @valid_user.email,
             :password => @valid_user.password
           }
    friendly_url_forwarding_aux(:register, :profile, user)
  end

  private
  
  #assert that the email field has a correct HTML
  def assert_email_field(email = nil, options = {})
    assert_input_field( 
      "text",
      "user[email]",
      email, 
      User::EMAIL_SIZE,
      User::EMAIL_MAX_LENGTH,
      options
    )
  end

  #assert that the password field has a correct HTML
  def assert_password_field(password_field_name = "password", options = {})
    assert_input_field(
      "password",
      "user[#{password_field_name}]",
      nil,
      User::PASSWORD_SIZE,
      User::PASSWORD_MAX_LENGTH,
      options
    )
  end

  #assert that the screen name field has a correct HTML
  def assert_screen_name_field(screen_name = nil, options = {})
    assert_input_field(
      "text",
      "user[screen_name]",
      screen_name,
      User::SCREEN_NAME_SIZE,
      User::SCREEN_NAME_MAX_LENGTH,
      options
    )
  end

  #user login function
  def try_to_login(user, options = {})
    user_hash = {
      :screen_name => user.screen_name,
      :password => user.password
    }
    user_hash.merge!(options)
    post :login, :user => user_hash
  end

  #user register function
  def try_to_register(user)
    post :register, :user => { :screen_name => user.screen_name,
                               :email => user.email,
                               :password => user.password
                             }
  end

  #Authorize a user
  def authorize(user)
    @request.session[:user_id] = user.id
  end

  #forvarding URL
  def friendly_url_forwarding_aux(test_page, protected_page, user)
    get protected_page

    assert_response :redirect
    assert_redirected_to :action => "login"
    post test_page, :user => user
    assert_response :redirect
    #assert_redirected_to :action => protected_page

    assert_nil session[:protected_page]
  end

  #extract a cookie value
  def cookie_value(symbol)
    cookies[symbol.to_s].value.first
  end

  #extract a cookie expiration time
  def cookie_expires(symbol)
    cookies[symbol.to_s].expires
  end
end
