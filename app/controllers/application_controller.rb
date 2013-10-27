class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize
  
  delegate :allow?, to: :current_permission
  helper_method :allow?
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
  end
  helper_method :current_user
  
  def current_permission
    if params[:theater_id].blank?
      @current_permission ||= Permission.new(current_user)
    else
      @current_permission ||= Permission.new(current_user, params[:theater_id].to_i)
    end
  end
  
  def authorize
    if !current_permission.allow?(params[:controller], params[:action])
      if params[:controller].split('/').first == "api"
        render :text => "404 Not Found", :status => 404
      else
        redirect_to new_admin_session_path, alert: 'Not authorized'
      end
    end
  end
end
