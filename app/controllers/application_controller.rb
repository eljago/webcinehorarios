# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format.json? }
  before_action :miniprofiler
  before_action :authorize

  delegate :allow?, to: :current_permission
  helper_method :allow?


  def raise_route_not_found!
    respond_to do |format|
      format.all { render :status => 404, body: nil }
    end
  end

  private

  def current_permission
    @current_permission ||= Permission.new(current_member)
  end

  def authorize
    # if current member is not allowed:
    if !current_permission.allow?(params[:controller], params[:action])
      if params[:controller].split('/').first == "api"
        render :status => 404, body: nil
      else
        redirect_to root_path, alert: 'No está Autorizado'
      end
    end
  end

  def after_sign_in_path_for(resource)
    admin_path
  end


  def get_date
    @date = Date.current
    if params[:date].present?
      date_array = params[:date].split('-')
      @date = Date.new(date_array[0].to_i, date_array[1].to_i, date_array[2].to_i)
    end
  end


  def miniprofiler
    if current_member && current_member.admin?
      Rack::MiniProfiler.authorize_request
    end
  end

end
