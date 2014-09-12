class Admin::OpinionsController < ApplicationController
  before_filter :get_opinion, only: [:edit, :update, :destroy]
  
  def index
    @opinions = Opinion.all
  end
  
  def new
    @opinion = Opinion.new
  end
  
  def create
    @opinion = Opinion.new(opinion_params)

    if @opinion.save
      redirect_to [:admin, :opinions], notice: 'Opinion was successfully created.'
    else
      render action: "new"
    end
  end
  
  def edit
  end
  
  def update
    if @opinion.update_attributes(opinion_params)
      redirect_to [:admin, :opinions], notice: 'Opinion was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @opinion.destroy

    redirect_to admin_opinions_path
  end
  
  private
  
  def get_opinion
    @opinion = Opinion.find(params[:id])
  end
  
  def opinion_params
    params.require(:opinion).permit :author, :comment, :date
  end
  
end
