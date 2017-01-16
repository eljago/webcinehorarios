class Api::V1::PeopleController < Api::V1::ApiController

  def index
    per_page = params[:perPage].present? ? params[:perPage] : 15
    people_count = Person.text_search(params[:query]).count
    people = Person.order('created_at DESC').text_search(params[:query])
      .paginate(page: params[:page], per_page: per_page).all
    response = {count: people_count, people: people}
    respond_with response
  end

  def create
    respond_with :api, Person.create(person_params)
  end

  def destroy
    respond_with Person.destroy(params[:id])
  end

  def update
    person = Person.find(params[:id])
    person.update_attributes(person_params)
    respond_with person, json: person
  end

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

  def person_params
    params.require(:people).permit(
      :name,
      :remote_image_url,
      :image,
      :imdb_code,
      images_attributes: [
        :id,
        :remote_image_url,
        :image,
        :backdrop,
        :poster,
        :_destroy
      ]
    )
  end
end