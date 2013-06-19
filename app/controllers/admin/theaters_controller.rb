class Admin::TheatersController < ApplicationController
  before_filter :get_theaterable
  before_filter :get_theater, only: [:show, :edit, :update, :destroy]
  
  def index
    @theaters =
      if params[:city_id]
        Theater.includes(:cinema).where(city_id: params[:city_id]).order('cinemas.name, theaters.name').all
      elsif params[:cinema_id]
        Theater.includes(:city).where(cinema_id: params[:cinema_id]).order('cities.name, theaters.name').all
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
    @theater = @theaterable.theaters.new(params[:theater])

    if @theater.save
      redirect_to [:admin, @theaterable, :theaters], notice: 'Theater was successfully created.'
    else
      render action: "new"
    end
  end
  
  def update
    if @theater.update_attributes(params[:theater])
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
        City.find(params[:city_id])
      elsif params[:cinema_id]
        Cinema.find(params[:cinema_id])
      end
  end
end
