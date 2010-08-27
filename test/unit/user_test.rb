require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  def setup
    @error_messages = ActiveRecord::Errors.default_error_messages
    @valid_user = users(:valid_user)
    @invalid_user = users(:invalid_user)
  end
  # This is valid user validation
  def test_user_validity
    #assert users(:valid_user).valid?
    assert @valid_user.valid?
  end

  # This is invalid user validation
  def test_user_invalidity
    #assert !users(:invalid_user).valid?
    assert !@invalid_user.valid?
    attributes = [ :screen_name, :email, :password ]
    attributes.each do |attribute|
      assert @invalid_user.errors.invalid?(attribute)
    end
  end

  def test_uniqueness_of_screen_name_and_email
    user_repeat = User.new( :screen_name => @valid_user.screen_name,
                            :email => @valid_user.email,
                            :password => @valid_user.password
                          )
    assert !user_repeat.valid?
    assert_equal @error_messages[:taken], user_repeat.errors.on(:screen_name)
    assert_equal @error_messages[:taken], user_repeat.errors.on(:email)
  end

  def test_screen_name_minimum_length
    user = @valid_user
    min_length = User::SCREEN_NAME_MIN_LENGTH

    user.screen_name = "q" * (min_length - 1)
    assert !user.valid?, "#{user.screen_name} should rise a minimum length error"
    correct_error_message = sprintf(@error_messages[:too_short], min_length)
    assert_equal correct_error_message, user.errors.on(:screen_name)

    user.screen_name = "q" * min_length
    assert user.valid?, "#{user.screen_name} should should be ok to pass"
  end

  def test_screen_name_maximum_length
    user = @valid_user
    max_length = User::SCREEN_NAME_MAX_LENGTH

    user.screen_name = "q" * (max_length + 1)
    assert !user.valid?, "#{user.screen_name} should rise a maximum length error"
    correct_error_message = sprintf(@error_messages[:too_long], max_length)
    assert_equal correct_error_message, user.errors.on(:screen_name)

    user.screen_name = "q" * max_length
    assert user.valid?, "#{user.screen_name} should should be ok to pass"
  end

  def test_password_minimum_length
    user = @valid_user
    min_length = User::PASSWORD_MIN_LENGTH

    user.password = "q" * (min_length - 1)
    assert !user.valid?, "#{user.password} should rise a minimum length error"
    correct_error_message = sprintf(@error_messages[:too_short], min_length)
    assert_equal correct_error_message, user.errors.on(:password)

    user.password = "q" * min_length
    assert user.valid?, "#{user.password} should should be ok to pass"
  end

  def test_password_maximum_length
    user = @valid_user
    max_length = User::PASSWORD_MAX_LENGTH

    user.password = "q" * (max_length + 1)
    assert !user.valid?, "#{user.password} should rise a maximum length error"
    correct_error_message = sprintf(@error_messages[:too_long], max_length)
    assert_equal correct_error_message, user.errors.on(:password)

    user.password = "q" * max_length
    assert user.valid?, "#{user.password} should should be ok to pass"
  end

  def test_email_maximum_length
    user = @valid_user
    max_length = User::EMAIL_MAX_LENGTH

    user.email = "q" * (max_length - user.email.length + 1) +user.email
    assert !user.valid?, "#{user.email} should rise a maximum length error"
    correct_error_message = sprintf(@error_messages[:too_long], max_length)
    assert_equal correct_error_message, user.errors.on(:email)
  end

  def test_email_with_valid_examples
    user = @valid_user
    valid_endings = %w{com org net ru}
    valid_emails = valid_endings.collect do |ending|
      "foo.bar_1-9@baz-quux0.example.#{ending}"
    end
    valid_emails.each do |email|
      user.email = email
      assert user.valid?, "#{email} must be a valid email address"
    end
  end

  def test_email_with_invalid_examples
    user = @valid_user
    invalid_emails = %w{test@test.c test@test,com test@test@iwiw.com @bs.cei bds@sasds..cdo sdfs(@ddfs.com asdfj@asfkl.sdfff}
    invalid_emails.each do |email|
      user.email = email
      assert !user.valid?, "#{email} this invalid mail passed registration"
      assert_equal "must be a valid address", user.errors.on(:email)
    end
  end

  def test_screen_name_with_valid_examples
    user = @valid_user
    valid_screen_names = %w{test re_st bbbggaaa}
    valid_screen_names.each do |screen_name|
      user.screen_name = screen_name
      assert user.valid? , "#{screen_name} did not passed the test, but it should not"
    end
  end

  def test_screen_name_with_invalid_examples
    user = @invalid_user
    invalid_screen_names = %w{-123 !wej# q tuzik/a wqer.2123}
    invalid_screen_names.each do |screen_name|
      user.screen_name = screen_name
      assert !user.valid? , "#{screen_name} did passed the test, but it should not"
    end
  end
end
