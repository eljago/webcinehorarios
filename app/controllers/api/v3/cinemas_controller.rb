module Api
  module V3
    class CinemasController < Api::V3::ApiController
      
      def show
        @cinema = Cinema.find(params[:id])
      end
    end
  end
end
