class Api::V1::ShowsController < Api::V1::ApiController

  before_action :set_videos_image_url, only: [:create, :update]

  def index
    per_page = params[:perPage].present? ? params[:perPage] : 15
    shows_count = Show.text_search(params[:query]).count
    shows = Show.text_search(params[:query]).order('created_at DESC')
      .paginate(page: params[:page], per_page: per_page).all
    response = {count: shows_count, shows: shows}
    respond_with response
  end

  def create
    respond_with :api, :v1, Show.create(show_params)
  end

  def destroy
    respond_with Show.destroy(params[:id])
  end

  def update
    show = Show.find(params[:id])
    show.update_attributes(show_params)
    respond_with show, json: show
  end

  def select_shows
    q = params[:input].split.map(&:capitalize).join(" ")
    searchResult = Show.select([:id, :name, :image]).text_search(q).order(:name)

    respond_to do |format|
      format.json do
        render json: {
          shows: searchResult.map do |e|
            {value: e.id, label: "#{e.name}", image_url: e.image.smallest.url}
          end
        }
      end
    end
  end

  private

  def show_params
    params.require(:shows).permit(
      :name,
      :active,
      :remote_image_url,
      :image,
      :information,
      :imdb_code,
      :imdb_score,
      :metacritic_url,
      :metacritic_score,
      :rotten_tomatoes_url,
      :rotten_tomatoes_score,
      :debut,
      :rating,
      genre_ids: [],
      show_person_roles_attributes: [
        :id,
        :person_id,
        :character,
        :show_id,
        :actor,
        :director,
        :_destroy
      ],
      images_attributes: [
        :id,
        :remote_image_url,
        :image,
        :_destroy
      ],
      videos_attributes: [
        :id,
        :name,
        :code,
        :video_type,
        :remote_image_url,
        :outstanding,
        :_destroy
      ]
    )
  end

  def set_videos_image_url
    videos_attrs = params[:shows][:videos_attributes]
    if videos_attrs.present?
      videos_attrs.each do |index|
        video_attributes = videos_attrs[index]
        # IF ITS UPDATING AN EXISTING VIDEO ...
        if video_attributes[:id].present?
          db_video = Video.find(video_attributes[:id])
          if db_video && db_video.code == video_attributes[:code] &&
            db_video.video_type == video_attributes[:video_type]
            return
          end
        end
        # continue if the video is new or the code or video_type is different
        if video_attributes[:code].present? && video_attributes[:video_type].present?
          if video_attributes[:video_type] === 'youtube'
            video_attributes[:remote_image_url] = "http://img.youtube.com/vi/#{video_attributes[:code]}/0.jpg"
            puts video_attributes[:remote_image_url]
          elsif video_attributes[:video_type] == "vimeo"
            api_url = "http://vimeo.com/api/v2/video/#{video_attributes[:code]}.json"
            s = open(URI.escape(api_url)).read
            video_json = JSON.parse(s)
            video_attributes[:remote_image_url] = video_json.first["thumbnail_large"]
          end
        end
      end
    end
  end

end
