
class CommunityController < ApplicationController
  helper :profile
  helper :spec

  before_filter :community_params

  def index
    @title = "Community"
    @letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("")
    if params[:id]
      if params[:id].length >= 1 and params[:id].length <= 3
        @initial = params[:id]

        #made a checking for all incoming parameters
#        specs = Spec.search_on_last_name (  :page => params[:page],
#                                 :conditions => ["last_name LIKE ?", @initial+"%"],
#                                 :order => "last_name, first_name")
        specs = Spec.find( :all, :conditions => ["last_name LIKE ?", @initial+"%"],
                          :order => "last_name, first_name")
        users = specs.collect { |spec| spec.user }
        @users = users.paginate(:page => @curr_page, :per_page => @per_page)
      else
        #redirect to error page
      end
    else
      #redirect to error pages
    end
  end

#  def browse
#    @title = "Browse"
#    return if params[:commit].nil?
#
#    search_pattern = {}
#    if not params[:min_age].to_i == 0 and not params[:max_age].to_i == 0
#      search_pattern[:birthdate] = params[:min_age].to_i..params[:max_age].to_i
#    end
#
#    if params[:gender] == "Male" or params[:gender] == "Female"
#      search_pattern[:gender] = params[:gender]
#    end
#
#    #specs = Spec.search :condition => search_pattern
#    specs = Spec.find_by_sql()
#    @users = specs.collect { |spec| spec.user }.paginate(:page => @curr_page, :per_page => @per_page)
#
#  end

  def search
    @title = "Search"
    if params[:q]
      query = params[:q]
      
#      @users = User.find_with_ferret(query)
#      specs = Spec.find_with_ferret(query)
#      faqs = Faq.find_with_ferret(query)

      @users = User.search params[:q]
      specs = Spec.search params[:q]

      @users.concat(specs.collect { |spec| spec.user}).uniq!
      @users = @users.sort_by { |user| user.spec.last_name }

      @users = @users.paginate(:page => @curr_page, :per_page => @per_page)

    end
  end

  private

  def community_params
    @curr_page = params[:page] || 1
    @per_page = 10
  end
end
