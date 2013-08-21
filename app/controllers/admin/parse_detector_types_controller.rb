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
    @parse_detector_type = @function_type.parse_detector_types.new(params[:parse_detector_type])

    if @parse_detector_type.save
      redirect_to [:admin, @function_type, :parse_detector_types], notice: 'Parse Detector Type was successfully created.'
    else
      render action: "new"
    end
  end
  
  def update
    @parse_detector_type = ParseDetectorType.find(params[:parse_detector_type_id])
    
    if @theater.update_attributes(params[:parse_detector_type])
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
end
