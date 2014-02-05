# encoding: utf-8
class Admin::AwardsController < ApplicationController

  def index
    @awards = Award.order('date DESC').all
  end
  
  def new
    @award = Award.new
    @award_types = AwardType.order('name ASC').all
  end
  
  def edit
    @award = Award.find(params[:id])
    @award_types = AwardType.order('name ASC').all
  end
  
  def create
    @award = Award.new(params[:award])
    
    if @award.save
      redirect_to [:admin, :awards], notice: 'Award creado con éxito.'
    else
      @award_types = AwardType.order('name ASC').all
      render action: "new"
    end
  end
  
  def update
    @award = Award.find(params[:id])

    if @award.update_attributes(params[:award])
      redirect_to [:admin, :awards], notice: 'Award actualizado con éxito.'
    else
      @award_types = AwardType.order('name ASC').all
      render action: "edit"
    end
  end
  
  def destroy
    @award = Award.find(params[:id])
    @award.destroy

    redirect_to admin_awards_url
  end
end
