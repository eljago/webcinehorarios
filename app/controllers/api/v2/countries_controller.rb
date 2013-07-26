module Api
  module V2
    class CountriesController < Api::V2::ApiController
      def index
        @countries = Country.all
      end
    end
  end
end
