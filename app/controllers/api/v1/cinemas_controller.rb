module Api
  module V1
    class CinemasController < Api::V1::ApiController
      def show
        if params[:id] == 5
          @cinema = Cinema.includes(:theaters).where('(theaters.cinema_id = ? OR theaters.cinema_id = 6) AND theaters.active = ?',params[:id],true)
          .order('theaters.name ASC').all
        else
          @cinema = Cinema.includes(:theaters).where('theaters.cinema_id = ? AND theaters.active = ?',params[:id],true)
          .order('theaters.name ASC').all
        end
      end
    end
  end
end
