module Api
  module V4
    class FunctionsController < Api::V4::ApiController
      before_filter :get_date
      
      def index
        if params[:theater_id].present?
          @functions = Function.where(theater_id: params[:theater_id]).joins(:show)
          .where(date: @date, show_id: 1..Float::INFINITY)
          .order('shows.debut DESC, shows.id')
          @cache_date = @date.strftime '%Y%m%d'
        else
          render_missing_params
        end
      end
      
    end
  end
end