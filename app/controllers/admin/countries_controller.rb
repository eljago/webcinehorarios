# encoding: utf-8
class Admin::CountriesController < ApplicationController
  
  before_action :get_country, only: [:edit, :update, :destroy]
  
  def index
    @countries = Country.all
  end
  
  def new
    @country = Country.new
  end
  
  def edit
  end
  
  def create
    @country = Country.new(country_params)

    if @country.save
      respond_to do |format|
        format.html do
          redirect_to [:admin, :countries], notice: 'País Actualizado Exitosamente.'
        end
        format.js
      end
    else
      render action: "new"
    end
  end
  
  def update
    if @country.update_attributes(country_params)
      redirect_to [:admin, :countries], notice: 'País Actualizado Exitosamente.'
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
  
  def country_params
    params.require(:country).permit(:name)
  end
end
