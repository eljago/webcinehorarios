module Api
  module V1
    class CinemasController < Api::V1::ApiController
      def show
          @cinema = Cinema.includes(:theaters).where('theaters.cinema_id = ? AND theaters.active = ?',params[:id],true)
          .order('theaters.name ASC').all
      end
    end
  end
end
