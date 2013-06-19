module Api
  module V1
    class CitiesController < Api::V1::ApiController
      def index
        @cities = City.where('country_id = ?',params[:country_id]).order(:name)
        @cinemas = Cinema.includes(:theaters).order('cinemas.id, theaters.name')
      end
    end
  end
end
