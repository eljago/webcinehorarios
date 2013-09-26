module Api
  module V2
    class CinemasController < Api::V2::ApiController
      
      def show_cinemas
        # /api/shows/id/show_cinemas.json
        date = Date.current
        @cinemas = Cinema.includes(theaters: :functions).where(functions: {show_id: params[:show_id], date: date}).all
      end
      
    end
  end
end
