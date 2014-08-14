module Api
  module V1
    class TheatersController < Api::V1::ApiController
      
      def show_theaters_joins
        date = Date.current

        @theaters = Theater.joins(:functions).where(functions: {show_id: params[:show_id], date: date})
        .select('theaters.id, theaters.name, theaters.cinema_id').where('theaters.active = ?',true)
        .order('theaters.name ASC').uniq
        @theaters.each do |theater|
          theater.cinema_id = 5 if theater.cinema_id == 6
        end
      end
    end
  end
end
