# encoding: utf-8
class Admin::AwardsController < ApplicationController

  def index
    @awards = Award.order('date DESC')
  end
  
  def new
    @award = Award.new
    @award_types = AwardType.order('name ASC')
  end
  
  def edit
    @award = Award.find(params[:id])
    @award_types = AwardType.order('name ASC')
  end
  
  def create
    @award = Award.new(award_params)
    
    if @award.save
      redirect_to [:admin, :awards], notice: 'Award creado con éxito.'
    else
      @award_types = AwardType.order('name ASC')
      render action: "new"
    end
  end
  
  def update
    @award = Award.find(params[:id])

    if @award.update_attributes(award_params)
      redirect_to [:admin, :awards], notice: 'Award actualizado con éxito.'
    else
      @award_types = AwardType.order('name ASC')
      render action: "edit"
    end
  end
  
  def destroy
    @award = Award.find(params[:id])
    @award.destroy

    redirect_to admin_awards_url
  end
  
  private
  
  def award_params
    params.require(:award).permit :name, :active, :date, :image, :award_type_id, award_specific_categories_attributes: [ :name, :award_category_id, :award_id, :winner_type ]
  end
end
