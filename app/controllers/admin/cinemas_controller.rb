class Admin::CinemasController < ApplicationController

  def index
    @cinemas = Cinema.order('id').select('id, name, information, image, slug')
  end
  
  def new
    @cinema = Cinema.new
  end
  
  def edit
    @cinema = Cinema.select('id, name, information, slug').find(params[:id])
  end
  
  def create
    @cinema = Cinema.new(cinema_params)
    
    if @cinema.save
      redirect_to [:admin, :cinemas], notice: 'Cinema was successfully created.'
    else
      render action: "new"
    end
  end
  
  def update
    @cinema = Cinema.find(params[:id])

    if @cinema.update_attributes(cinema_params)
      redirect_to [:admin, :cinemas], notice: 'Cinema was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @cinema = Cinema.find(params[:id])
    @cinema.destroy

    redirect_to admin_cinemas_url
  end
  
  private
  
  def cinema_params
    params.require(:cinema).permit :image, :information, :name, :remote_image_url, theater_ids: []
  end
end
