module Api
  module V2
    class TheatersController < Api::V2::ApiController
      
      def index
        @theaters = Theater.where(cinema_id: params[:cinema_id]).select('theaters.id, theaters.name')
          .where('theaters.active = ?', true).order('theaters.name').all
      end
      
      def show_theaters
        date = Date.current

        @theaters = Theater.joins(:functions).where(functions: {show_id: params[:show_id], date: date})
        .select('theaters.id, theaters.name, theaters.cinema_id').where('theaters.active = ?', true)
        .order('theaters.name ASC').uniq.all
      end
      
      def favorite_theaters
        date = Date.current
        
        unless params[:favorites].blank?
          favorites = params[:favorites].split(',')
          @favorite_theaters = Theater.includes(functions: [:show, :function_types, :showtimes])
          .select('theaters.id, theaters.name, theaters.cinema_id')
          .where('theaters.active = ? AND theaters.id IN (?) AND functions.show_id = ? AND functions.date = ?', true, favorites, params[:show_id], date)
          .order('theaters.name ASC, showtimes.time ASC').uniq.all
        end
        @favorite_theaters ||= []
      end
    end
  end
end
