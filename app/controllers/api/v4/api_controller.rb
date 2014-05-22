class Api::V4::ApiController < ApplicationController
  before_filter :restrict_access
  respond_to :json

  def api_route_not_found!
    render :json => {error: {code:  1, mensaje: "Ruta para #{params[:unmatched_route]} no existe", type: "CHRoutingError"} }
  end
  
  private 

  def restrict_access
    if Rails.env.production?
      authenticate_or_request_with_http_token do |token, options|
        ApiKey.exists?(access_token: token)
      end
    end
  end
  
end