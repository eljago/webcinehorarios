class Api::V1::PeopleController < Api::V1::ApiController

  def select_people
    q = params[:input].split.map(&:capitalize).join(" ")
    peopleResult = Person.select([:id, :name]).
                          where("name like :q", q: "%#{q}%").
                          order('name').order(:name)

    respond_to do |format|
      format.json { render json: {people: peopleResult.map { |e| {value: e.id, label: "#{e.name}"} }} }
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