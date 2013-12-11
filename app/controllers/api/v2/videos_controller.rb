module Api
  module V2
    class VideosController < Api::V2::ApiController
      
      def index
        page = params[:page].blank? ? 1 : params[:page]
        
        @videos = Video.includes(:videoable).order('created_at DESC').select([:id, :name, :code, :image, :videoable_type, :videoable_id]).paginate(page: page, per_page: 10).all
      end
      
    end
  end
end
