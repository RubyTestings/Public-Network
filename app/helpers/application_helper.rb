# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  require 'string'
  require 'will_paginate_ext'
  require 'ThinkingSphinx_Search'

  #returns HTML text for text field
  def text_field_for( form, field,
                      size = HTML_TEXT_FIELD_SIZE,
                      maxlength = DB_STRING_MAX_LENGTH)
    label = content_tag("label", "#{field.humanize}:", :for => field)
    form_field = form.text_field field, :size => size, :maxlength => maxlength
    content_tag("div", "#{label} #{form_field}", :class => "form_row")
  end

  #
  def form_before_submition
    { :onsubmit => "return check_form_before_submition(this);" }
  end 

  #generates links for site navigation
  def nav_link(text, options)
    options[:action] ||= "index"
    link_to_unless_current text, options
  end

  #check the user to logged in
  def logged_in?
    not session[:user_id].nil?
  end
  
  #this function returns a set of css files for for each page
  #this function is unfinished
  def upload_additional_css(alternative_css_list = nil)

    ##
    # :css_file_name => array of hashes or hash with parameters
    ##
    css_files_list = alternative_css_list || {
      :site => { :any => true },
      :profile => [{:controller => "user", :action => "index"},
                   {:controller => "faq", :action => "edit"},
                   {:controller => "profile", :action => "show"}]
    }

    css_upload_set = ""

    css_files_list.each_pair do |css_file, allowed_pages|

      if allowed_pages.kind_of? Hash
        allowed_pages.each_pair do |key, value|
          if key == :any and value == true
            css_upload_set += stylesheet_link_tag css_file.to_s
          end
        end
      elsif allowed_pages.kind_of? Array
        allowed_pages.each do |allowed_page|
          if current_page?( allowed_page )
            css_upload_set += stylesheet_link_tag css_file.to_s
          end
        end
      else
        #should be some errors
      end
    end

    css_upload_set
  end
  
end
