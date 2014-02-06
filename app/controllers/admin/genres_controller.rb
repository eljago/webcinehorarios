class Admin::GenresController < ApplicationController

  before_filter :get_genre, only: [:edit, :update, :destroy]
  
  def index
    @genres = Genre.order(:name).all
  end
  
  def new
    @genre = Genre.new
  end
  
  def edit
  end
  
  def create
    @genre = Genre.new(params[:genre])

    if @genre.save
      redirect_to [:admin, :genres], notice: 'Genre was successfully created.'
    else
      render action: "new"
    end
  end
  
  def update

    if @genre.update_attributes(params[:genre])
      redirect_to [:admin, :genres], notice: 'Genre was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @genre.destroy

    redirect_to admin_genres_url
  end
  
  private
  
  def get_genre
    @genre = Genre.find(params[:id])
  end
end
