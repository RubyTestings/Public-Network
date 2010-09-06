module ProfileHelper

  #return users profile url
  def profile_for(user)
    profile_url(:screen_name => user.screen_name )
  end

end
