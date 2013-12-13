module Api
  module V3
    class TheatersController < Api::V3::ApiController
      
      def index
        @theaters = Theater.where(cinema_id: params[:cinema_id]).select('theaters.id, theaters.name')
          .where('theaters.active = ?', true).order('theaters.name').all
      end
      
      def show_theaters
        date = Date.current

        @theaters = Theater.joins(:functions).where(functions: {show_id: params[:show_id], date: date})
        .select('theaters.id, theaters.name, theaters.cinema_id').where('theaters.active = ?', true)
        .order('theaters.name ASC').uniq.all
        @show_id = params[:show_id]
      end
      
      def favorite_theaters
        date = Date.current

        @show = Show.find(params[:show_id])
        unless params[:favorites].blank?
          favorites = params[:favorites].split(',')
          @favorite_theaters = Theater.includes(:functions => [:function_types, :showtimes])
          .select('theaters.id, theaters.name, theaters.cinema_id')
          .where('theaters.active = ? AND theaters.id IN (?) AND functions.show_id = ? AND functions.date = ?', true, favorites, params[:show_id], date)
          .order('theaters.name ASC, showtimes.time ASC').all
        end
        @favorite_theaters ||= []
      end
      
      def theater_coordinates
        @theaters = Theater.select([:id, :name, :cinema_id, :latitude, :longitude, :address])
        .order(:cinema_id, :name).where(active: true).all
      end
      
    end
  end
end
