class Admin::ParseDetectorTypesController < ApplicationController
  
  def index
    @function_type = FunctionType.find(params[:function_type_id])
    @parse_detector_types = @function_type.parse_detector_types.includes(:cinema)
  end
  
  def show
    @function_type = FunctionType.find(params[:function_type_id])
    @parse_detector_type = ParseDetectorType.find(params[:id])
  end
  
  def new
    @function_type = FunctionType.find(params[:function_type_id])
    @parse_detector_type = @function_type.parse_detector_types.new
  end
  
  def edit
    @function_type = FunctionType.find(params[:function_type_id])
    @parse_detector_type = ParseDetectorType.find(params[:id])
  end
  
  def create
    @function_type = FunctionType.find(params[:function_type_id])
    @parse_detector_type = @function_type.parse_detector_types.new(parse_detector_type_params)

    if @parse_detector_type.save
      redirect_to [:admin, @function_type, :parse_detector_types], notice: 'Parse Detector Type was successfully created.'
    else
      render action: "new"
    end
  end
  
  def update
    @parse_detector_type = ParseDetectorType.find(params[:id])
    @function_type = @parse_detector_type.function_type
    
    if @parse_detector_type.update_attributes(parse_detector_type_params)
      redirect_to [:admin, @function_type, :parse_detector_types], notice: 'Parse Detector Type was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @function_type = FunctionType.find(params[:function_type_id])
    @parse_detector_type = ParseDetectorType.find(params[:id])
    @parse_detector_type.destroy

    redirect_to [:admin, @function_type, :parse_detector_types]
  end
  
  private
  
  def parse_detector_type_params
    params.require(:parse_detector_type).permit :cinema_id, :function_type_id, :name
  end
end
