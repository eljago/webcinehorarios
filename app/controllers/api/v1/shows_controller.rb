class Api::V1::ShowsController < Api::V1::ApiController

  def index
    respond_with Show.order('created_at DESC').paginate(page: params[:page], per_page: 10).all
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

  private

  def show_params
    params.require(:shows).permit(
      :name,
      :remote_image_url,
      :image,
      :imdb_code,
    )
  end
end
