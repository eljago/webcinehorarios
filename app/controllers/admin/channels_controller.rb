class Admin::ChannelsController < ApplicationController
  
  before_filter :get_channel, only: [:show, :edit, :update, :destroy]
  
  def index
    @channels = Channel.all
  end
  
  def show
  end
  
  def new
    @channel = Channel.new
  end
  
  def edit
  end
  
  def create
    @channel = Channel.new(params[:channel])

    if @channel.save
      redirect_to [:admin, :channels], notice: 'Channel was successfully created.'
    else
      render action: "new"
    end
  end
  
  def update
    if @channel.update_attributes(params[:channel])
      redirect_to [:admin, :channels], notice: 'Channel was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @channel.destroy

    redirect_to admin_channels_path
  end
  
  private
  
  def get_channel
    @channel = Channel.find(params[:id])
  end
end
