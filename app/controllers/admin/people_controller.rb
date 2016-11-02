class Admin::PeopleController < ApplicationController
  
  before_action :get_person, only: [:show, :edit, :update, :destroy]
  
  def index
    @title = 'Personas'
    @app_name = 'PeopleApp'
    @props = {defaultPerson: Person.new}
    @prerender = false
    render file: 'react/render'
  end
  
  def show
    respond_to do |format|
      format.html
      format.json { render json: {person: { id: @person.id, name: @person.name } } }
    end
  end
  
  def new
    @person = Person.new
  end
  
  def edit
  end
  
  def create
    @person = Person.new(person_params)

    if @person.save
      redirect_to [:new, :admin, :person], notice: 'Person was successfully created.'
    else
      render action: "new"
    end
  end
  
  def update

    if @person.update_attributes(person_params)
      redirect_to [:admin, :people], notice: 'Person was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @person.destroy

    redirect_to [:admin, :people]
  end
  
  def select_people
    q = params[:q].split.map(&:capitalize).join(" ")
    @people = Person.select([:id, :name]).
                          where("name like :q", q: "%#{q}%").
                          order('name').order(:name)

    respond_to do |format|
      format.json { render json: {people: @people.map { |e| {id: e.id, text: "#{e.name}"} }} }
    end
  end
  
  private
  
  def get_person
    @person = Person.friendly.find(params[:id])
  end
  
  def person_params
    params.require(:person).permit :birthdate, :birthplace, :deathdate, :height, :information, :name, :image, :remote_image_url, :imdb_code
  end
end
