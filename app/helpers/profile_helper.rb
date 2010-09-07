module ProfileHelper

  #return users profile url
  def profile_for(user)
    profile_url(:screen_name => user.screen_name )
  end

  #return true if hiding the edit links
  def hide_edit_links?
    !@hide_edit_links.nil? && @hide_edit_links == true 
  end

end
