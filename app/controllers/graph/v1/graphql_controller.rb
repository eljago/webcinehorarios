module Graph
  module V1
    class GraphqlController < ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        result = RelaySchema.execute(
          params[:query],
          variables: ensure_hash(params[:variables])
        )
        render json: result
      end

      private

      def ensure_hash(query_variables)
        if query_variables.blank?
          {}
        elsif query_variables.is_a?(String)
          JSON.parse(query_variables)
        else
          query_variables
        end
      end

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