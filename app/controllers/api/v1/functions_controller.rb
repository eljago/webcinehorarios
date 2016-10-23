module Api
  module V1
    class FunctionsController < Api::V1::ApiController

      def index
        # functions = Function.where(date: params[:date], theater_id: params[:theater_id])
        #   .includes(:show, :function_types, :parsed_show).order('functions.show_id DESC')
        # functions_hash = functions.map do |f|
        #   function_hash = f.as_json
        #   function_hash["show"] = f.show.as_json
        #   function_hash["show"]["image"] = f.show.image_url(:smaller)
        #   function_hash["function_types"] = f.function_types.as_json
        #   function_hash["parsed_show"] = f.parsed_show.as_json
        #   function_hash
        # end
        # response = {functions: functions_hash}
        # respond_with response

        shows = Show.includes(:functions => :parsed_show).references(:functions)
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
        respond_with response
      end

      def update
        function = Function.find(params[:id])
        function.update_attributes(function_params)
        respond_with function, json: function
      end

      def destroy
        respond_with Function.destroy(params[:id])
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
