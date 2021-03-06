# encoding: utf-8
class Admin::AwardSpecificCategoriesController < ApplicationController

  def index
    @award = Award.find(params[:award_id])
    @award_specific_categories = @award.award_specific_categories.order('name ASC')
  end
  
  def new
    @award = Award.find(params[:award_id])
    @award_specific_category = @award.award_specific_categories.new
    @shows = Show.select([:id, :name]).order('shows.name ASC')
    @award_categories = AwardCategory.select([:id, :name]).order('award_categories.name ASC')
    @people = Person.select([:id, :name]).order('people.name ASC')
  end
  
  def edit
    @award_specific_category = AwardSpecificCategory.includes(:nominations => :nomination_person_roles).find(params[:id])
    @award = @award_specific_category.award
    @shows = Show.select([:id, :name]).order('shows.name ASC')
    @award_categories = AwardCategory.select([:id, :name]).order('award_categories.name ASC')
    @people = Person.select([:id, :name]).order('people.name ASC')
  end
  
  def create
    @award = Award.find(params[:award_id])
    @award_specific_category = @award.award_specific_categories.new(award_specific_category_params)
    
    if @award_specific_category.save
      redirect_to [:admin, @award, :award_specific_categories], notice: 'Award Specific Category  creado con éxito.'
    else
      @shows = Show.select([:id, :name]).order('shows.name ASC')
      @award_categories = AwardCategory.select([:id, :name]).order('award_categories.name ASC')
      @people = Person.select([:id, :name]).order('people.name ASC')
      render action: "new"
    end
  end
  
  def update
    @award_specific_categories = AwardSpecificCategory.find(params[:id])
    award = @award_specific_categories.award

    if @award_specific_categories.update_attributes(award_specific_category_params)
      redirect_to [:admin, award, :award_specific_categories], notice: 'Award Specific Category actualizado con éxito.'
    else
      @award = @award_specific_category.award
      @shows = Show.select([:id, :name]).order('shows.name ASC')
      @award_categories = AwardCategory.select([:id, :name]).order('award_categories.name ASC')
      @people = Person.select([:id, :name]).order('people.name ASC')
      render action: "edit"
    end
  end
  
  def destroy
    @award_specific_category = AwardSpecificCategory.find(params[:id])
    @award_specific_category.destroy
    award = @award_specific_category.award

    redirect_to [:admin, award, :award_specific_categories]
  end
  
  def award_specific_category_params
    params.require(:award_specific_category).permit :name, :award_category_id, :award_id, :winner_type, nominations_attributes: [ :winner, :show_id, :award_specific_category_id, nomination_person_roles_attributes: [ :person_id, :nomination_id ] ]
  end
end
