# encoding: utf-8
class Admin::AwardTypesController < ApplicationController

  def index
    @award_types = AwardType.order('name ASC')
  end
  
  def new
    @award_type = AwardType.new
  end
  
  def edit
    @award_type = AwardType.find(params[:id])
  end
  
  def create
    @award_type = AwardType.new(params[:award_type])
    
    if @award_type.save
      redirect_to [:admin, :award_types], notice: 'Award Type  creado con éxito.'
    else
      render action: "new"
    end
  end
  
  def update
    @award_type = AwardType.find(params[:id])

    if @award_type.update_attributes(params[:award_type])
      redirect_to [:admin, :award_types], notice: 'Award Type actualizado con éxito.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @award_type = AwardType.find(params[:id])
    @award_type.destroy

    redirect_to admin_award_types_url
  end
  
end
