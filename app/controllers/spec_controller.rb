class SpecController < ApplicationController

  #before_filter :protect, :only => :index
  before_filter :protect
  before_filter :define_variables


  def index
    redirect_to @redirect_url
  end

  def edit
    @title = "Edit Spec"
    @user = User.find(session[:user_id])
    @user.spec ||= Spec.new
    @spec = @user.spec

    if param_posted?(:spec)
      if @user.spec.update_attributes(params[:spec])
        flash[:notice] = "Changes saved."
        redirect_to @redirect_url
      end
    end
  end

  private

  # here defined several useful constants
  def define_variables
    @redirect_url = {:controller => "user", :action => "index"}
    @referer = request.env['HTTP_REFERER'] || @redirect_url
  end

end
