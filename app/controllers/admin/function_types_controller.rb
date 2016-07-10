class Admin::FunctionTypesController < ApplicationController
  
  before_action :get_function_type, only: [:edit, :update, :destroy]

  def index
    @function_types = FunctionType.all
  end
  
  def new
    @function_type = FunctionType.new
  end
  
  def edit
  end
  
  def create
    @function_type = FunctionType.new(function_type_params)

    if @function_type.save
      redirect_to [:admin, :function_types], notice: 'Function Type was successfully created.'
    else
      render action: "new"
    end
  end
  
  def update

    if @function_type.update_attributes(function_type_params)
      redirect_to [:admin, :function_types], notice: 'Function Type was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @function_type.destroy

    redirect_to [:admin, :function_types]
  end
  
  private
  
  def get_function_type
    @function_type = FunctionType.find(params[:id])
  end
  
  def function_type_params
    params.require(:function_type).permit :name, :color, cinema_ids: []
  end
end
