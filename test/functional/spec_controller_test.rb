require File.dirname(__FILE__) + '/../test_helper'
require 'spec_controller'

# Re-raise errors caught by the controller.
class SpecController; def rescue_action(e) raise e end; end

class SpecControllerTest < Test::Unit::TestCase

  fixtures :users
  fixtures :specs

  def setup
    @controller = SpecController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @user = users(:valid_user)
    @spec = specs(:valid_spec)
  end

  # test the redirection process when user unauthorized
  def test_index_unauthorize
    get :index
    assert_response :redirect
    assert_redirected_to :controller => "user", :action => "login"
  end

  # test the redirection process when user authorized
  def test_index_authorize
    authorize @user
    get :index
    assert_response :redirect
    assert_redirected_to :controller => "user", :action => "index"
  end

  #test form to be displayed correctly
  def test_edit_form
    authorize @user
    get :edit
    assert_response :success

    @title = assigns(:title)
    assert_equal "Edit Spec", @title
    assert_template "edit"

    assert_form_tag "/spec/edit"
    assert_tag "input", :attributes => { :name => "spec[first_name]" }
    assert_tag "input", :attributes => { :name => "spec[last_name]" }
    assert_tag "input", :attributes => { :type => "radio",
                                         :name => "spec[gender]",
                                         :value => "Male" }
    assert_tag "input", :attributes => { :type => "radio",
                                         :name => "spec[gender]",
                                         :value => "Female" }
    assert_tag "select", :attributes => { :name => /spec\[birthdate\(.*\)\]/ }
    assert_tag "input", :attributes => { :name => "spec[occupation]" }
    assert_tag "input", :attributes => { :name => "spec[zip_code]" }
    assert_submit_button "Update"
  end

  # test successful edit
  def test_edit_success
    authorize @user
    #get :edit
    post :edit,
         :spec => { :first_name => "First Name",
                    :last_name => "Last Name",
                    :gender => "Male",
                    :occupation => "new job",
                    :zip_code => "12312"
                  }
    spec = assigns(:spec)
    new_user = User.find(spec.user_id)
    assert_equal new_user.spec, spec
    assert_equal "Changes saved.", flash[:notice]
    assert_response :redirect
    assert_redirected_to :controller => "user", :action => "index"
  end

  # test edit failure
  def test_edit_failure
    authorize @user
    too_long_string = "a" * (DB_STRING_MAX_LENGTH + 1)
    post :edit,
         :spec => { :first_name => too_long_string,
                    :last_name => too_long_string,
                    :gender => "Gomosek",
                    :occupation => too_long_string,
                    :city => too_long_string,
                    :state => too_long_string,
                    :zip_code => "nozip"
                  }
    assert_response :success
    assert_template "edit"
    asser_error_field

    test_fields = %w(first_name last_name gender occupation city state zip_code)
    test_fields.each do |field|
      assert_tag "li", :content => /#{field.humanize}/
    end

    error_div = { :tag => "div",
                  :attributes => { :class => "fieldWithErrors" } }

    Spec::STRING_FIELDS.each do |field|
      assert_input_field "text", "spec[#{field}]", too_long_string,
                         HTML_TEXT_FIELD_SIZE, DB_STRING_MAX_LENGTH,
                         :parent => error_div
    end

  end

  private

  # check whether errorField is appear
  def asser_error_field
    assert_tag "div", :attributes => {
      :id => "errorExplanation",
      :class => "errorExplanation"
    }
  end
end
