class SiteController < ApplicationController

  #layout "test_different"
  
  def index
    @title = "Index page"
  end

  def about
    @title = "About page"
  end

  def help
    @title = "Help page"
  end
end
