class Api::V1::ShowsController < Api::V1::ApiController

  before_action :set_videos_image_url, only: [:create, :update]

  def index
    per_page = params[:perPage].present? ? params[:perPage] : 15
    shows = Show.order('created_at DESC').text_search(params[:query])
      .paginate(page: params[:page], per_page: per_page)
    shows_hash = shows.as_json
    shows_hash.each_with_index do |show_hash, index|
      show_hash["image_url"] = shows[index].image_url :smaller
    end
    shows_count = Show.text_search(params[:query]).count
    response = {count: shows_count, shows: shows_hash}
    respond_with response
  end

  def billboard
    shows = Show.joins(:functions).where(active: true, functions: {date: Date.current})
      .order("shows.debut DESC").distinct
    shows_hash = shows.as_json
    shows_hash.each_with_index do |show_hash, index|
      show_hash["image_url"] = shows[index].image_url :smaller
    end
    response = {shows: shows_hash}
    respond_with response
  end

  def comingsoon
    shows = Show.where('(debut > ? OR debut IS ?) AND active = ?', Date.current, nil, true)
      .order("debut ASC")
    shows_hash = shows.as_json
    shows_hash.each_with_index do |show_hash, index|
      show_hash["image_url"] = shows[index].image_url :smaller
    end
    response = {shows: shows_hash}
    respond_with response
  end

  def create
    respond_with :api, Show.create(show_params)
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
    searchResult = Show.select([:id, :name]).text_search(q).order(:name)

    respond_to do |format|
      format.json do
        render json: {
          shows: searchResult.map do |e|
            {value: e.id, label: e.name, image_url: e.image_url(:smaller)}
          end
        }
      end
    end
  end

  private

  def show_params
    params.require(:shows).permit(
      :name,
      :name_original,
      :year,
      :duration,
      :active,
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
      country_ids: [],
      functions_attributes: [
        :id,
        :date,
        :showtimes,
        :_destroy,
        function_type_ids: []
      ],
      show_person_roles_attributes: [
        :id,
        :person_id,
        :character,
        :actor,
        :director,
        :_destroy
      ],
      images_attributes: [
        :id,
        :remote_image_url,
        :image,
        :backdrop,
        :poster,
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
    if params[:shows].present?
      videos_attrs = params[:shows][:videos_attributes]

      if videos_attrs.present?
        videos_attrs.each do |index|
          video_attributes = videos_attrs[index]

          video_type = nil
          code = nil

          if video_attributes[:id].present?
            db_video = Video.find(video_attributes[:id])
            video_type = video_attributes[:video_type].present? ? video_attributes[:video_type] : db_video.video_type
            code = video_attributes[:code].present? ? video_attributes[:code] : db_video.code
          else
            video_type = video_attributes[:video_type].present? ? video_attributes[:video_type] : 'youtube'
            code = video_attributes[:code].present? ? video_attributes[:code] : nil
          end

          if video_type.present? && code.present?
            if video_type === 'youtube'
              video_attributes[:remote_image_url] = "http://img.youtube.com/vi/#{code}/0.jpg"
            elsif video_type === 'vimeo'
              api_url = "http://vimeo.com/api/v2/video/#{code}.json"
              s = open(URI.escape(api_url)).read
              video_json = JSON.parse(s)
              video_attributes[:remote_image_url] = video_json.first["thumbnail_large"]
            end
          end
        end

      end
    end
  end

end
