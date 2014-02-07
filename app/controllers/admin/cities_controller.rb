class Admin::CitiesController < ApplicationController
    
  def index
    @country = Country.find(params[:country_id])
    @cities = @country.cities.order(:name)
  end
  
  def new
    @country = Country.find(params[:country_id])
    @city = @country.cities.new
  end
  
  def edit
    @city = City.find(params[:id])
    @country = @city.country
  end
  
  def create
    @country = Country.find(params[:country_id])
    @city = @country.cities.new(params[:city])

    if @city.save
      redirect_to [:admin, @country, :cities], notice: 'City was successfully created.'
    else
      render action: "new"
    end
  end
  
  def update
    @city = City.find(params[:id])
    @country = @city.country

    if @city.update_attributes(params[:city])
      redirect_to [:admin, @country, :cities], notice: 'City was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @city = City.find(params[:id])
    @country = @city.country
    @city.destroy

    redirect_to [:admin, @country, :cities]
  end
  
  private

  def get_country
    @country = Country.find(params[:country_id])
  end

  def get_city_country
    @city = City.find(params[:id])
    @country = @city.country
  end
end
