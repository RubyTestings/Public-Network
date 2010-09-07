require "#{File.dirname(__FILE__)}/../test_helper"

class RememberMeTest < ActionController::IntegrationTest
 
  include ApplicationHelper
  fixtures :users

  def setup
    temp_user = users(:valid_user)
    temp_user[:password] = "goodpass"
    @user = temp_user
  end


  def test_css_files_valid_upload
    login_valid_user
    assert_response :redirect
    assert_redirected_to :controller => "user", :action => "index"

    get "user/index"
    is_css_file_presented("site")
    is_css_file_presented("profile")
  end

  private

  def login_valid_user
    post "user/login", :user => {
      :screen_name => @user.screen_name,
      :password => @user.password,
      :remember_me => "1"
    }
  end

  def is_css_file_presented(css_file)
    is_tag_file_presented("link","text/css",/.*#{css_file}\.css.*/)
  end
  
  def is_javascript_file_presented(script_file)
    is_tag_file_presented("script","text/javascript",/.*#{script_file}\.js.*/)
  end
  
  def is_tag_file_presented(tag,type,file_pattern)
    assert_tag :tag => tag,
               :attributes => { :type => type,
                                :rel => "Stylesheet",
                                :href => file_pattern }
  end
end