
require 'digest/sha1'

class User < ActiveRecord::Base

  SCREEN_NAME_MIN_LENGTH = 4
  SCREEN_NAME_MAX_LENGTH = 20
  PASSWORD_MIN_LENGTH = 4
  PASSWORD_MAX_LENGTH = 40
  EMAIL_MAX_LENGTH = 50
  SCREEN_NAME_RANGE = SCREEN_NAME_MIN_LENGTH..SCREEN_NAME_MAX_LENGTH
  PASSWORD_RANGE = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH

  #values for View
  SCREEN_NAME_SIZE = 20
  PASSWORD_SIZE = 10
  EMAIL_SIZE = SCREEN_NAME_SIZE
  
  COOKIES_EXPIRATION_TIME = 1

  attr_accessor   :remember_me
  
  validates_uniqueness_of  :screen_name, :email
  validates_length_of      :screen_name, :within => SCREEN_NAME_RANGE
  validates_length_of      :password,    :within => PASSWORD_RANGE
  validates_length_of      :email,       :maximum => EMAIL_MAX_LENGTH
  
  #validates_presence_of    :email

  validates_format_of      :screen_name,
                           :with => /^[A-Z0-9_]*$/i,
                           :message => "must contain only latters" +
                                       "numbers, and underscores"
  validates_format_of      :email,
                           :with => /^[A-Z0-9\._\-]+@([A-Z0-9\-]+\.){1,3}[A-Z]{2,4}$/i,
                           :message => "must be a valid address"
  
                         
  #def validate
  #  errors.add(:email, "must Contain @.") unless email.include? ("@")
  #  if screen_name.include?(" ")
  #    errors.add(:screen_name, "can not contain spaces")
  #  end
  #end

  #log user in
  def login!(session)
    session[:user_id] = self.id
    session[:screen_name] = self.screen_name
  end

  #logout user
  def self.logout!(session,cookies)
    session[:user_id] = nil
    session[:screen_name] = nil
    cookies.delete :authorization_token
  end

  #remember user if remember me checked
  def remember!(cookies)
    expiration_time = COOKIES_EXPIRATION_TIME.years.from_now
    cookies[:remember_me] = {
      :value => "1",
      :expires => expiration_time
    }
    
    self.authorization_token = unique_identifier

    save!
    cookies[:authorization_token] = {
      :value => authorization_token,
      :expires => expiration_time
    }
  end

  #function to check whether the user is remembered or not
  def remember_me?
    remember_me == "1"
  end



  #function to delete all information about user account
  def forget!(cookies)
    cookies.delete(:remember_me)
    cookies.delete(:authorization_token)
  end

  #Clear the password field
  def clear_password!
    self.password = nil
  end

  private

  #generation of unique session hash
  def unique_identifier
    Digest::SHA2.hexdigest("#{screen_name}:#{password}")
  end
end
