class Admin::ProgramsController < ApplicationController
  
  before_filter :get_channel, only: [:index, :new, :create]
  before_filter :get_program_channel, only: [:show, :edit, :update, :destroy]
  
  def index
    @programs = @channel.programs.order(:name)
  end

  def show
  end
  
  def new
    @program = @channel.programs.new
  end
  
  def edit
  end
  
  def create
    @program = @channel.programs.new(program_params)

    if @program.save
      redirect_to [:admin, @channel, :programs], notice: 'Program was successfully created.'
    else
      render action: "new"
    end
  end
  
  def update

    if @program.update_attributes(program_params)
      redirect_to [:admin, @channel, :programs], notice: 'Program was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @program.destroy

    redirect_to [:admin, @channel, :programs]
  end
  
  private

  def get_channel
    @channel = Channel.find(params[:channel_id])
  end

  def get_program_channel
    @program = Program.find(params[:id])
    @channel = @program.channel
  end
  
  def program_params
    params.require(:program).permit :name, :time
  end
end
