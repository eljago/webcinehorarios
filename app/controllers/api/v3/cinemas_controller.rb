module Api
  module V3
    class CinemasController < Api::V3::ApiController
      
      def show
        @cinema = Cinema.includes(:theaters).where(theaters: {active: true}).references(:theaters).order('theaters.name').find(params[:id])
      end
    end
  end
end
