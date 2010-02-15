# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require_dependency 'sortable_helper'

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include Sortable
  include NinjaDispatchErrors
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  layout nil
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  private
  def check_logged_in
    unless logged_in?
      flash[:notice] = "You must be logged in to perform that action." 
      redirect_to login_url
    end
  end
end
