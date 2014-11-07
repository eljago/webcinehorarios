module Api
  module V3
    class TheatersController < Api::V3::ApiController
      before_filter :get_date, only: [:show_theaters, :favorite_theaters, :show]
      
      def show_theaters
        @theaters = Theater.joins(:functions).where(functions: {show_id: params[:show_id], date: @date})
        .where('theaters.active = ?', true)
        .order('theaters.name ASC').uniq
        @show_id = params[:show_id]
      end
     
      def favorite_theaters
        @show = Show.find(params[:show_id])
        unless params[:favorites].blank?
          favorites = params[:favorites].split(',')
          @favorite_theaters = Theater.includes(functions: [:function_types, :showtimes])
          .where('theaters.active = ? AND theaters.id IN (?) AND functions.show_id = ? AND functions.date = ?', true, favorites, @show.id, @date)
          .order('theaters.name ASC').references(:functions)
        end
        @favorite_theaters ||= []
        @cache_date = @date.strftime '%Y%m%d'
      end
      
      def show
        @functions = Function.includes(:show, :showtimes, :function_types)
          .order('shows.debut DESC, shows.id, showtimes.time ASC')
          .where(functions: { date: @date, theater_id: params[:id] } )
        
        @cache_date = @date.strftime '%Y%m%d'
          
        @theater = Theater.includes(:cinema).where(id: params[:id]).first
        @cinema_name = @theater.cinema.name
      end
      
      def theater_coordinates
        @theaters = Theater.select([:id, :name, :cinema_id, :latitude, :longitude, :address])
        .order(:cinema_id, :name).where(active: true)
      end
      
      private
      
      def get_date
        @date = Date.current
        unless params[:date].blank?
          date_array = params[:date].split('-')
          @date = Date.new(date_array[0].to_i, date_array[1].to_i, date_array[2].to_i)
        end
      end
    end
  end
end
