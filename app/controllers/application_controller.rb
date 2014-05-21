# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }
  before_filter :authorize
  
  delegate :allow?, to: :current_permission
  helper_method :allow?
  
  
  def raise_route_not_found!
    render :template => "errors/404", :status => 404
  end
  
  private
  
  def current_permission
    @current_permission ||= Permission.new(current_member)
  end
  
  def authorize
    # if current member is not allowed:
    unless current_permission.allow?(params[:controller], params[:action])
      if params[:controller].split('/').first == "api"
        render :text => "404 Not Found", :status => 404
      else
        redirect_to admin_path, alert: 'No está Autorizado'
      end
    end
  end
  
  def after_sign_in_path_for(resource)
    admin_path
  end
  
    
end
