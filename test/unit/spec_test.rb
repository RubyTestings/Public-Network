require File.dirname(__FILE__) + '/../test_helper'

class SpecTest < Test::Unit::TestCase
  fixtures :specs


  def setup
    @valid_spec = specs(:valid_spec)
  end

  # Test maximum length of each field in db
  def test_max_length
    Spec::STRING_FIELDS.each do |field|
      assert_length :max, @valid_spec, field, DB_STRING_MAX_LENGTH
    end
  end

  #test a blank spec saving
  def test_blank_spec
    blank_spec = Spec.new(:user_id => @valid_spec.user_id)
    assert blank_spec.save, blank_spec.errors.full_messages.join("\n")
  end

  #test the invalid birthdates
  def test_invalid_bithdays
    spec = @valid_spec
    invalid_birthdates = [Date.new(Spec::START_YEAR - 1), Date.today + 1.year]
    invalid_birthdates.each do |birthdate|
      spec.birthdate = birthdate
      assert !spec.valid?, "#{birthdate} should not pass validation"
    end
  end

  #test the valid birthdates
  def test_valid_bithdays
    spec = @valid_spec
    valid_birthdates = [Date.today, @valid_spec.birthdate]
    valid_birthdates.each do |birthdate|
      spec.birthdate = birthdate
      assert spec.valid?, "#{birthdate} should pass validation"
    end
  end

  #test the invalid zip codes
  def test_invalid_zip_codes
    spec = @valid_spec
    invalid_zip_codes = ["0A123","0009","123456"]
    invalid_zip_codes.each do |zip_codes|
      spec.zip_code = zip_codes
      assert !spec.valid?, "#{zip_codes} should not pass validation"
    end
  end

  #test the valid zip codes
  def test_valid_zip_codes
    spec = @valid_spec
    valid_zip_codes = ["12343","01234"]
    valid_zip_codes.each do |zip_codes|
      spec.zip_code = zip_codes
      assert spec.valid?, "#{zip_codes} should not pass validation"
    end
  end

  #test for valid gender
  def test_gender_with_valid_examples
    spec = @valid_spec
    Spec::VALID_GENDERS.each do |gender|
      spec.gender = gender
      assert spec.valid?, "#{gender} should pass validation"
    end
  end

    #test for valid gender
  def test_gender_with_invalid_examples
    spec = @valid_spec
    valid_genders = ["Man","Woman"]
    valid_genders.each do |gender|
      spec.gender = gender
      assert !spec.valid?, "#{gender} should pass validation"
    end
  end
end
