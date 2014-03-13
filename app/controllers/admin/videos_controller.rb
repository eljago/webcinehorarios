# encoding: utf-8
class Admin::VideosController < ApplicationController
  
  before_filter :get_video, only: [:edit, :update, :destroy]
  
  def index
    @videos = Video.order('videos.created_at DESC').page(params[:page]).per_page(10)
  end
  
  def new
    @video = Video.new
  end
  
  def edit
  end
  
  def create
    unless params[:video][:code].blank?
      params[:video][:remote_image_url] = "http://img.youtube.com/vi/#{params[:video][:code]}/0.jpg"
    end
    
    @video = Video.new(params[:video])

    if @video.save
      redirect_to [:admin, :videos], notice: 'Video Creado Exitosamente.'
    else
      render action: "new"
    end
  end
  
  def update
    unless params[:video][:code].blank?
      video = Video.find(params[:id].to_i)
      puts video.code.dump
      puts params[:video][:code].dump
      puts video.blank?
      if !video.blank? && video.code != params[:video][:code]
        params[:video][:remote_image_url] = "http://img.youtube.com/vi/#{params[:video][:code]}/0.jpg"
      end
    end
    
    if @video.update_attributes(params[:video])
      redirect_to [:admin, :videos], notice: 'Video Actualizado Exitosamente.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @video.destroy

    redirect_to [:admin, :videos]
  end
  
  private
  
  def get_video
    @video = Video.find(params[:id])
  end
end
