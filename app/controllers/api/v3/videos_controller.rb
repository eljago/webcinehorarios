module Api
  module V3
    class VideosController < Api::V3::ApiController
      
      def index
        page = params[:page].blank? ? 1 : params[:page]
        
        @videos = Video.includes(:show).where('shows.active = ?', true).order('videos.created_at DESC').select([:id, :name, :code, :image, :videoable_type, :videoable_id]).paginate(page: page, per_page: 15)
        
      end
      
    end
  end
end
