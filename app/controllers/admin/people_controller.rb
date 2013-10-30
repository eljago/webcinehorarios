class Admin::PeopleController < ApplicationController
  
  before_filter :get_person, only: [:show, :edit, :update, :destroy]
  
  def index
    letter = params[:letter].blank? ? 'A' : params[:letter] 
    @people = Person.where('name like ?', "#{letter}%").order(:name).all
  end
  
  def show
  end
  
  def new
    @person = Person.new
    @people = Person.select([:id, :name]).order(:name).all
  end
  
  def edit
    @people = Person.select([:id, :name]).order(:name).all
  end
  
  def create
    @person = Person.new(params[:person])

    if @person.save
      redirect_to [:new, :admin, :person], notice: 'Person was successfully created.'
    else
      render action: "new"
    end
  end
  
  def update

    if @person.update_attributes(params[:person])
      redirect_to [:admin, :people], notice: 'Person was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @person.destroy

    redirect_to [:admin, :people]
  end
  
  private
  
  def get_person
    @person = Person.find(params[:id])
  end
end
