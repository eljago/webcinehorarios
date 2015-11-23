module Api
  module V4
    class FunctionsController < Api::V4::ApiController
      before_filter :get_date
      
      def index
        if params[:theater_id].present?
          @shows = Show.joins(:functions).where(id: 1..Float::INFINITY)
          .where('functions.theater_id = ? AND functions.date = ?', params[:theater_id], @date)
          .order('shows.debut DESC, shows.id').uniq
          @cache_date = @date.strftime '%Y%m%d'
        else
          render_missing_params
        end
      end
      
    end
  end
end