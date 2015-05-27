module Api
  module V4
    class ApiController < ApplicationController
      before_filter :restrict_access
      respond_to :json
      
      def render_missing_params
        code = 1000
        message = 'Parameters missing'
        render_error code, message
      end
      
      def render_record_not_found
        code = 1001
        message = 'Record not found'
        render_error code, message
      end
  
      private 
      
      def render_error code, message
        render :json => {:error => {:code => code, :message => message} }
      end
  
      def restrict_access
        if Rails.env.production?
          authenticate_or_request_with_http_token do |token, options|
            ApiKey.exists?(access_token: token)
          end
        end
      end
      
    end
  end
end
