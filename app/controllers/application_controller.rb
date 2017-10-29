class ApplicationController < ActionController::Base
  before_action :require_login
  protect_from_forgery with: :exception
  check_authorization
  include SessionsHelper

  rescue_from CanCan::AccessDenied do |exception|
      respond_to do |format|
        flash[:danger] = exception.message
        format.json { head :forbidden, content_type: 'text/html' }
        format.html { redirect_to (request.referer ||  main_app.root_url) }
        format.js   { head :forbidden, content_type: 'text/html' }
      end
  end

  private
 
  def require_login
    unless logged_in?
      flash[:danger] = "You must be logged in to access this section"
      redirect_to login_url # halts request cycle
    end
  end

end
