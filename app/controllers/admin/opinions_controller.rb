class Admin::OpinionsController < ApplicationController
  def index
    @opinions = Opinion.all
  end
  
  def new
    @opinion = Opinion.new
  end
  
  def create
    @opinion = Opinion.new(params[:opinion])

    if @opinion.save
      redirect_to [:admin, :opinions], notice: 'Opinion was successfully created.'
    else
      render action: "new"
    end
  end
  
  def edit
    @opinion = Opinion.find(params[:id])
  end
  
  def show
    @opinion = Opinion.find(params[:id])
  end
  
  def update
    @opinion = Opinion.find(params[:id])
    if @opinion.update_attributes(params[:opinion])
      redirect_to [:admin, :opinions], notice: 'Opinion was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @opinion = Opinion.find(params[:id])
    @opinion.destroy

    redirect_to admin_opinions_path
  end
end
