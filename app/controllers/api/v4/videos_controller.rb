module Api
  module V4
    class VideosController < Api::V4::ApiController
      
      def index
        page = params[:page].blank? ? 1 : params[:page]
        
        @videos = Video.includes(:show).where('shows.active = ? AND videos.video_type = ?', true, 0)
        .references(:show).order('videos.created_at DESC')
        .paginate(page: page, per_page: 15)
        
      end
      
    end
  end
end
