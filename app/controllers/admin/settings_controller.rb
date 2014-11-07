class Admin::SettingsController < ApplicationController
  def index
    # to get all items for render list
    @settings = Settings.unscoped
  end

  def edit
    @setting = Settings.unscoped.find(params[:id])
    @setting[:value] = YAML.load(@setting[:value])
  end
  
  def update
    @setting = Settings.find(params[:id])
    @setting.var = setting_params[:var]
    @setting.value = setting_params[:value]

    if @setting.save
      redirect_to admin_settings_path, notice: "Saved."
    else
      render action: "edit"
    end
  end
  
  private
  
  def setting_params
    params.require(:settings).permit :var, :value
  end
end