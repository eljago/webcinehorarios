module Api
  module V4
    class ShowsController < Api::V4::ApiController
      before_filter :get_date, only: :theaters
      
      def billboard
        current_day = Date.current
        date = current_day + ((3-current_day.wday) % 7)
        @shows = Show.joins(:functions).where('shows.active = ? AND shows.debut <= ? AND functions.date = ?', true, date, current_day)
        .order("shows.debut DESC").uniq
      end
      
      def coming_soon
        date = Date.current
        @shows = Show.where('(debut > ? OR debut IS ?) AND active = ?', date, nil, true)
        .order("shows.debut")
      end
      
      def show
        if params[:id].present?
          if Show.exists?(:id => params[:id])
            @show = Show.find(params[:id])
          else
            render_record_not_found
          end
        else
          render_missing_params
        end
      end
      
      def theaters
        if params[:show_id].present?
          @theaters = Theater.joins(:functions).where(functions: {show_id: params[:show_id], date: @date})
          .where('theaters.active = ?', true)
          .order('theaters.cinema_id, theaters.name').uniq
          @show_id = params[:show_id]
        else
          render_missing_params
        end
      end
      
    end
  end
end
