class FaqController < ApplicationController

  before_filter :protect
  before_filter :define_variables

  def index
    redirect_to hub_url
  end

  def edit
    @title = "Edit FAQ"
    @user = User.find(session[:user_id])
    @user.faq ||= Faq.new
    @faq = @user.faq

    if param_posted?(:faq)
      if @user.faq.update_attributes(params[:faq])
        flash[:notice] = "FAQ changed"
        redirect_to @redirect_url
      end
    end
  end

  private

  # here defined several useful constants
  def define_variables
    @redirect_url = hub_url
    @referer = request.env['HTTP_REFERER'] || @redirect_url
  end

end
