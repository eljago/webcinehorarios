class Admin::CinemasController < ApplicationController

  def index
    @cinemas = Cinema.order('id').select('id, name, information, image').all
  end
  
  def new
    @cinema = Cinema.new
  end
  
  def edit
    @cinema = Cinema.select('id, name, information').find(params[:id])
  end
  
  def create
    @cinema = Cinema.new(params[:cinema])
    
    if @cinema.save
      redirect_to [:admin, :cinemas], notice: 'Cinema was successfully created.'
    else
      render action: "new"
    end
  end
  
  def update
    @cinema = Cinema.find(params[:id])

    if @cinema.update_attributes(params[:cinema])
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
end
