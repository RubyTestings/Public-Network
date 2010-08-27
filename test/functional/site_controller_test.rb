require File.dirname(__FILE__) + '/../test_helper'
require 'site_controller'

# Re-raise errors caught by the controller.
class SiteController; def rescue_action(e) raise e end; end

class SiteControllerTest < Test::Unit::TestCase
  def setup
    @controller = SiteController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_index
    get :index
    title = assigns(:title)
    assert_equal "Index page", title
    assert_response :success
    assert_template "index"
  end

  def test_about
    get :about
    title = assigns(:title)
    assert_equal "About page", title
    assert_response :success
    assert_template "about"
  end

  def test_help
    get :help
    title = assigns(:title)
    assert_equal "Help page", title
    assert_response :success
    assert_template "help"
  end


  #test navigation before login
  def test_navigation_before_login
    get :index
    assert_tag "a", :content => /Register/,
                    :attributes => { :href => "/user/register"}
    assert_tag "a", :content => /Login/,
                    :attributes => { :href => "/user/login"}
    assert_no_tag "a", :content => /Home/
  end
  
end
