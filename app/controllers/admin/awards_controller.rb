# encoding: utf-8
class Admin::AwardsController < ApplicationController

  def index
    @awards = Award.order('date DESC').all
  end
  
  def new
    @award = Award.new
    @shows = Show.select([:id, :name]).order('shows.name ASC').all
    @award_categories = AwardCategory.select([:id, :name]).order('award_categories.name ASC').all
  end
  
  def edit
    @award = Award.includes(:award_specific_nominations => :nominations).find(params[:id])
    @shows = Show.select([:id, :name]).order('shows.name ASC').all
    @award_categories = AwardCategory.select([:id, :name]).order('award_categories.name ASC').all
  end
  
  def create
    @award = Award.new(params[:award])
    
    if @award.save
      redirect_to [:admin, :awards], notice: 'Award creado con éxito.'
    else
      render action: "new"
    end
  end
  
  def update
    @award = Award.find(params[:id])

    if @award.update_attributes(params[:award])
      redirect_to [:admin, :awards], notice: 'Award actualizado con éxito.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @award = Award.find(params[:id])
    @award.destroy

    redirect_to admin_awards_url
  end
end
