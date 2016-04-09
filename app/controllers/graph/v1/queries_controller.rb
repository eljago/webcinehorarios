module Graph
  module V1
    class QueriesController < ApplicationController

      def new
      end

      def create
        query_string = params[:query]
        query_variables = params[:variables] || {}
        result = RelaySchema.execute(query_string, variables: query_variables)
        render json: result
      end

      private

      # override authorize
      def authorize
        if Rails.env.production?
          authenticate_or_request_with_http_token do |token, options|
            ApiKey.exists?(access_token: token)
          end
        end
      end
    end
  end
end
