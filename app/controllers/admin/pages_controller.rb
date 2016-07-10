class Admin::PagesController < ApplicationController
  
  before_action :get_page, only: [:show, :edit, :update, :destroy]
  
  def index
    @pages = Page.all
  end
  
  def new
    @page = Page.new
  end
  
  def show
    @page = Page.find(params[:id])
  end

  def edit
  end
  
  def create
    @page = Page.new(params[:page])

    if @page.save
      redirect_to admin_pages_path, notice: 'Page was successfully created.'
    else
      render action: "new"
    end
  end
  
  def update
    if @page.update_attributes(params[:page])
      redirect_to [:admin,@page], notice: 'Page was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @page.destroy

    redirect_to admin_pages_path
  end
  
  private
  
  def get_page
    @page = Page.find(params[:id])
  end
end
