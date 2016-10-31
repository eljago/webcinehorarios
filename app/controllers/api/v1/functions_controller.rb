module Api
  module V1
    class FunctionsController < Api::V1::ApiController

      def index
        shows = Show.includes(:functions => [:function_types, :parsed_show]).references(:functions)
          .where('functions.date = ? AND functions.theater_id = ?', params[:date], params[:theater_id])
          .order('shows.debut DESC, functions.id ASC')

        shows_hash = []
        shows_hash = shows.map do |show|
          show_hash = show.as_json
          show_hash["functions"] = show.functions.map do |function|
            function_hash = function.as_json
            function_hash["function_types"] = function.function_type_ids
            function_hash["parsed_show"] = function.parsed_show.as_json
            function_hash
          end
          show_hash["image_url"] = show.image_url :smaller
          show_hash
        end
        response = {shows: shows_hash}
        respond_with response, json: response
      end

      def update
        function = Function.find(params[:id])
        function.update_attributes(function_params)
        respond_with function, json: function
      end

      def destroy
        respond_with Function.destroy(params[:id])
      end

      def copy_day
        theater = Theater.find(params[:theater_id])
        functions = theater.functions.where('functions.date = ?', params[:date])
        response = Function.transaction do
          functions.each do |function|
            func = function.dup
            func.function_type_ids = function.function_type_ids
            func.date = function.date.next
            func.save
          end
        end
        respond_with response, json: response
      end

      def delete_day
        theater = Theater.find(params[:theater_id])
        functions = theater.functions.where(date: params[:date])
        response = Function.transaction { functions.each(&:destroy) }
        respond_with response
      end

      def delete_onward
        theater = Theater.find(params[:theater_id])
        functions = theater.functions.where('functions.date >= ?', params[:date])
        response = Function.transaction { functions.each(&:destroy) }
        respond_with response
      end

      private

      def function_params
        params.require(:functions).permit(
          :show_id,
          :date,
          :showtimes,
          function_type_ids: []
        )
      end

    end
  end
end
