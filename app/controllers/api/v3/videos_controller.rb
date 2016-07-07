module Api
  module V3
    class VideosController < Api::V3::ApiController
      
      def index
        page = params[:page].blank? ? 1 : params[:page]
        
        @videos = Video.includes(:show).where('shows.active = ? AND videos.video_type = ? AND videos.outstanding = ?', true, 0, true).references(:show).order('videos.created_at DESC').paginate(page: page, per_page: 15)
        
      end
      
    end
  end
end
