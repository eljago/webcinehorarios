module Api
  module V1
    class FunctionsController < Api::V1::ApiController
      def index
        date = Date.current
        @functions = Function.includes(:show, :showtimes, :function_types)
          .order('shows.debut DESC, shows.id, showtimes.time ASC')
          .where(functions: { date: date, theater_id: params[:theater_id] } )
      end
        
      def show_functions
        date = Date.current
        @functions = Function.includes(:show, :function_types, :showtimes).select('functions.id, functions.date')
        .order('showtimes.time ASC')
        .where(theater_id: params[:theater_id], show_id: params[:show_id], date: date )
      end
    end
  end
end
