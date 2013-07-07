module Api
  module V2
    class TheatersController < Api::V2::ApiController
      
      def show_theaters_joins
        date = Date.current

        @theaters = Theater.joins(:functions).where(functions: {show_id: params[:show_id], date: date})
        .select('theaters.id, theaters.name, theaters.cinema_id').order('theaters.name ASC').uniq.all
      end
    end
  end
end
