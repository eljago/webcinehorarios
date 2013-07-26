module Api
  module V2
    class CitiesController < Api::V2::ApiController
      def index
        @cities = City.where('country_id = ?',params[:country_id]).order(:name).all
        @cinemas = Cinema.includes(:theaters).order('cinemas.id, theaters.name')
      end
    end
  end
end
