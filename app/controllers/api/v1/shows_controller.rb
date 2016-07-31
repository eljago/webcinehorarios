class Api::V1::ShowsController < Api::V1::ApiController

  def index
    respond_with Show.text_search(params[:query]).order('created_at DESC')
      .paginate(page: params[:page], per_page: 10).all
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
    searchResult = Show.select([:id, :name]).text_search(q).order(:name)

    respond_to do |format|
      format.json do
        render json: {
          shows: searchResult.map do |e|
            {value: e.id, label: "#{e.name}"}
          end
        }
      end
    end
  end

  private

  def show_params
    params.require(:shows).permit(
      :name,
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
      ]
    )
  end
end
