class ProfileController < ApplicationController

  def index
    @title = "Test Project Profiles"
  end

  def show
    screen_name = params[:screen_name]
    @user = User.find_by_screen_name(screen_name)
    if @user
      @title = "Test Project profile for user #{screen_name}"
    else
      flash[:notice] = "No user with screen name #{screen_name} found."
      redirect_to :action => "index"
    end
  end
end
