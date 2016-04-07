module Graph
  module V1
    class QueriesController < ApplicationController

      def new
      end

      def create
        query_string = params[:query]
        query_variables = params[:variables] || {}
        cache_key = Digest::MD5.hexdigest query_string
        result = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
          RelaySchema.execute(query_string, variables: query_variables)
        end
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
