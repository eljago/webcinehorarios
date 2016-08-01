class Api::V1::VideosController < Api::V1::ApiController

  def select_video_types
    respond_to do |format|
      format.json do
        render json: {
          video_types: Video.video_types.map do |vt|
            {value: vt[0], label: vt[0]}
          end
        }
      end
    end
  end

end