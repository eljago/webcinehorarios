# encoding: utf-8
class Admin::AwardCategoriesController < ApplicationController

  def index
    @award_categories = AwardCategory.order('name ASC')
  end
  
  def new
    @award_category = AwardCategory.new
  end
  
  def edit
    @award_category = AwardCategory.find(params[:id])
  end
  
  def create
    @award_category = AwardCategory.new(params[:award_category])
    
    if @award_category.save
      redirect_to [:admin, :award_categories], notice: 'Award Category  creado con éxito.'
    else
      render action: "new"
    end
  end
  
  def update
    @award_category = AwardCategory.find(params[:id])

    if @award_category.update_attributes(params[:award_category])
      redirect_to [:admin, :award_categories], notice: 'Award Category  actualizado con éxito.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @award_category = AwardCategory.find(params[:id])
    @award_category.destroy

    redirect_to admin_award_categories_url
  end
end
