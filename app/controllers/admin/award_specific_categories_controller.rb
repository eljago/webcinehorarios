# encoding: utf-8
class Admin::AwardSpecificCategoriesController < ApplicationController

  def index
    @award = Award.find(params[:award_id])
    @award_specific_categories = @award.award_specific_categories.order('name ASC').all
  end
  
  def new
    @award = Award.find(params[:award_id])
    @award_specific_category = @award.award_specific_categories.new
    @shows = Show.select([:id, :name]).order('shows.name ASC').all
    @award_categories = AwardCategory.select([:id, :name]).order('award_categories.name ASC').all
    @people = Person.select([:id, :name]).order('people.name ASC').all
  end
  
  def edit
    @award_specific_category = AwardSpecificCategory.includes(:nominations => :nomination_person_roles).find(params[:id])
    @award = @award_specific_category.award
    @shows = Show.select([:id, :name]).order('shows.name ASC').all
    @award_categories = AwardCategory.select([:id, :name]).order('award_categories.name ASC').all
    @people = Person.select([:id, :name]).order('people.name ASC').all
  end
  
  def create
    @award = Award.find(params[:award_id])
    @award_specific_category = @award.award_specific_categories.new(params[:award_specific_category])
    
    if @award_specific_category.save
      redirect_to [:admin, @award, :award_specific_categories], notice: 'Award Specific Category  creado con éxito.'
    else
      @shows = Show.select([:id, :name]).order('shows.name ASC').all
      @award_categories = AwardCategory.select([:id, :name]).order('award_categories.name ASC').all
      @people = Person.select([:id, :name]).order('people.name ASC').all
      render action: "new"
    end
  end
  
  def update
    @award_specific_categories = AwardSpecificCategory.find(params[:id])
    award = @award_specific_categories.award

    if @award_specific_categories.update_attributes(params[:award_specific_category])
      redirect_to [:admin, award, :award_specific_categories], notice: 'Award Specific Category actualizado con éxito.'
    else
      @award = @award_specific_category.award
      @shows = Show.select([:id, :name]).order('shows.name ASC').all
      @award_categories = AwardCategory.select([:id, :name]).order('award_categories.name ASC').all
      @people = Person.select([:id, :name]).order('people.name ASC').all
      render action: "edit"
    end
  end
  
  def destroy
    @award_specific_category = AwardSpecificCategory.find(params[:id])
    @award_specific_category.destroy
    award = @award_specific_category.award

    redirect_to [:admin, award, :award_specific_categories]
  end
end
