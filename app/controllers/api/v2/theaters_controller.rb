module Api
  module V2
    class TheatersController < Api::V2::ApiController
      
      def index
        @theaters = Theater.where(cinema_id: params[:cinema_id]).select('theaters.id, theaters.name')
          .order('theaters.name').all
      end
      
      def show_theaters
        date = Date.current

        @theaters = Theater.joins(:functions).where(functions: {show_id: params[:show_id], date: date})
        .select('theaters.id, theaters.name, theaters.cinema_id').order('theaters.name ASC').uniq.all
      end
    end
  end
end
