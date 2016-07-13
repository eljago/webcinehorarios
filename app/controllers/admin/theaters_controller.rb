class Admin::TheatersController < ApplicationController
  before_action :get_theaterable
  before_action :get_theater, only: [:show, :edit, :update, :destroy]

  def index
    @theaters =
      if params[:city_id]
        @theaterable.theaters.includes(:cinema).order('cinemas.name, theaters.name')
      elsif params[:cinema_id]
        @theaterable.theaters.includes(:city).order('cities.name, theaters.name')
      end
  end

  def show
  end

  def new
    @theater = @theaterable.theaters.new
  end

  def edit
  end

  def create
    @theater = @theaterable.theaters.new(theater_params)

    if @theater.save
      redirect_to [:admin, @theaterable, :theaters], notice: 'Theater was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    if @theater.update_attributes(theater_params)
      redirect_to [:admin, @theaterable, :theaters], notice: 'Theater was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @theater.destroy

    redirect_to [:admin, @theaterable, :theaters]
  end

  private

  def get_theater
    @theater = Theater.find(params[:id])
  end

  def get_theaterable
    @theaterable ||=
      if params[:city_id]
        City.friendly.find(params[:city_id])
      elsif params[:cinema_id]
        Cinema.friendly.find(params[:cinema_id])
      end
  end

  def theater_params
    params.require(:theater).permit(:cinema_id, :city_id, :address, :information, :latitude, :longitude, :name, :web_url, :active, :parse_helper, function_type_ids: [])
  end
end
