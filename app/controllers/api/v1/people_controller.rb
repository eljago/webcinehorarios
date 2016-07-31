class Api::V1::PeopleController < Api::V1::ApiController

  def select_people
    q = params[:input].split.map(&:capitalize).join(" ")
    searchResult = Person.select([:id, :name, :image]).text_search(q).order(:name)

    respond_to do |format|
      format.json do
        render json: {
          people: searchResult.map do |e|
            {value: e.id, label: "#{e.name}", image_url: e.image.smallest.url}
          end
        }
      end
    end
  end

  private

  def show_params
    params.require(:people).permit(
      :name,
      :remote_image_url,
      :image,
      :imdb_code
    )
  end
end