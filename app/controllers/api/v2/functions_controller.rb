module Api
  module V2
    class FunctionsController < Api::V2::ApiController
      def index
        date = Date.current
        @functions = Function.includes(:show, :showtimes, :function_types)
          .order('shows.debut DESC, shows.id, showtimes.time ASC')
          .where(functions: { date: date, theater_id: params[:theater_id] } ).all
        puts "v2"
      end
        
      def show_functions
        date = Date.current
        @functions = Function.includes(:show, :function_types, :showtimes).select('functions.id, functions.date')
        .order('showtimes.time ASC')
        .where(theater_id: params[:theater_id], show_id: params[:show_id], date: date ).all
      end
    end
  end
end
