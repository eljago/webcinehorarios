module Api
  module V1
    class CinemasController < Api::V1::ApiController
      def show
        @cinema = Cinema.find(params[:id])
        if params[:id] == "5"
          @theaters = Theater.where(cinema_id: [5,6], active: true).order('theaters.name ASC')
        else
          @theaters = Theater.where(cinema_id: params[:id], active: true).order('theaters.name ASC')
        end
      end
    end
  end
end
