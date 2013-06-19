class Admin::CountriesController < ApplicationController
  
  before_filter :get_country, only: [:show, :edit, :update, :destroy]
  
  def index
    @countries = Country.all
  end
  
  def show
  end
  
  def new
    @country = Country.new
  end
  
  def edit
  end
  
  def create
    @country = Country.new(params[:country])

    if @country.save
      redirect_to [:admin, :countries], notice: 'Country was successfully created.'
    else
      render action: "new"
    end
  end
  
  def update
    if @country.update_attributes(params[:country])
      redirect_to [:admin, :countries], notice: 'Country was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @country.destroy

    redirect_to admin_countries_path
  end
  
  private
  
  def get_country
    @country = Country.find(params[:id])
  end
end
