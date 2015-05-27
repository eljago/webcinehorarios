module Api
  module V4
    class TheatersController < Api::V4::ApiController
      
      def index
        if params[:country_name].present?
          country_name = params[:country_name]
          country = Country.find_by name: country_name
          @theaters = country.theaters.where(active: true).order([:cinema_id, :name])
        else
          render_missing_params
        end
      end
      
    end
  end
end