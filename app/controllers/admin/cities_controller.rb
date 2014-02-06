class Admin::CitiesController < ApplicationController
  
  before_filter :get_country, only: [:index, :new, :create]
  before_filter :get_city_country, only: [:edit, :update, :destroy]
  
  def index
    @cities = @country.cities.order(:name)
  end
  
  def new
    @city = @country.cities.new
  end
  
  def edit
  end
  
  def create
    @city = @country.cities.new(params[:city])

    if @city.save
      redirect_to [:admin, @country, :cities], notice: 'City was successfully created.'
    else
      render action: "new"
    end
  end
  
  def update

    if @city.update_attributes(params[:city])
      redirect_to [:admin, @country, :cities], notice: 'City was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def destroy
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
