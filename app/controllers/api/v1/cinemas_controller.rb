module Api
  module V1
    class CinemasController < Api::V1::ApiController
      def show
        if params[:id] == 5
          @cinema = Cinema.includes(:theaters).where('theaters.cinema_id = ? AND theaters.active = ?',params[:id],true)
          .order('theaters.name ASC').find(5)
          @cinema.theaters << Theater.where('theaters.cinema_id = ? AND theaters.active = ?',6,true).order('theaters.name ASC')
        else
          @cinema = Cinema.includes(:theaters).where('theaters.cinema_id = ? AND theaters.active = ?',params[:id],true)
          .order('theaters.name ASC').all
        end
      end
    end
  end
end
