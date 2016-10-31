module Api
  module V1
    class TheatersController < Api::V1::ApiController

      def index
        theaters = Theater.where(cinema_id: params[:cinema_id]).order(:name).all
        response = {theaters: theaters}
        respond_with response
      end

      def create
        respond_with :api, Theater.create(theater_params)
      end

      def destroy
        respond_with Theater.destroy(params[:id])
      end

      def update
        theater = Theater.find(params[:id])
        theater.update_attributes(theater_params)
        respond_with theater, json: theater
      end
      
      def show_theaters_joins
        date = Date.current

        @theaters = Theater.joins(:functions).where(functions: {show_id: params[:show_id], date: date})
        .select('theaters.id, theaters.name, theaters.cinema_id').where('theaters.active = ?',true)
        .order('theaters.name ASC').uniq
        @theaters.each do |theater|
          theater.cinema_id = 5 if theater.cinema_id == 6
        end
      end

      private

      def theater_params
        params.require(:theaters).permit(
          :name,
          :information,
          :address,
          :latitude,
          :longitude,
          :web_url,
          :active,
          :cinema_id,
          :city_id,
          functions_attributes: [
            :id,
            :date,
            :showtimes,
            :show_id,
            :theater_id,
            :_destroy,
            function_type_ids: []
          ]
        )
      end
    end
  end
end
