class Admin::PeopleController < ApplicationController
  
  before_filter :get_person, only: [:show, :edit, :update, :destroy]
  
  def index
    # letter = params[:letter].blank? ? 'A' : params[:letter] 
    # @people = Person.where('name like ?', "#{letter}%").order(:name)
    @people = Person.text_search(params[:query]).paginate(page: params[:page], per_page: 10)
  end
  
  def show
    respond_to do |format|
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
    @person = Person.find(params[:id])
  end
  
  def person_params
    params.require(:person).permit :birthdate, :birthplace, :deathdate, :height, :information, :name, :image, :remote_image_url, :imdb_code
  end
end
