# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def nav_link(text, options)
    link_to_unless_current text, options
  end

  #check the user to logged in
  def logged_in?
    not session[:user_id].nil?
  end
end
