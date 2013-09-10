module Api
  module V2
    class FunctionsController < Api::V2::ApiController
      before_filter :get_date, only: [:index, :show_functions]
      
      def index
        @functions = Function.includes(:show, :showtimes, :function_types)
        .select('function_types.name, shows.id, shows.name, shows.image, shows.debut, showtimes.time')
          .order('shows.debut DESC, shows.id, showtimes.time ASC')
          .where(functions: { date: @date, theater_id: params[:theater_id] } ).all
      end
        
      def show_functions
        @functions = Function.includes(:show, :function_types, :showtimes).select('functions.id, functions.date')
        .order('showtimes.time ASC')
        .where(theater_id: params[:theater_id], show_id: params[:show_id], date: @date ).all
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
