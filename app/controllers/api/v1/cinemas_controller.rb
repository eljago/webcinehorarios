module Api
  module V1
    class CinemasController < Api::V1::ApiController
      def show
        date = Date.current
        @cinema = Cinema.includes(theaters: :functions).where(id: params[:id], functions: {date: date}).order('theaters.name ASC').all
      end
      
      def show_cinemas
        # /api/shows/id/show_cinemas.json
        date = Date.current
        @cinemas = Cinema.includes(theaters: :functions).where(functions: {show_id: params[:show_id], date: date}).all
      end
      
    end
  end
end
