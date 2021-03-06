# encoding: utf-8
require 'open-uri'
require 'json'

class Admin::VideosController < ApplicationController
  
  before_action :get_video, only: [:edit, :update, :destroy]
  
  def index
    @videos = Video.order('videos.created_at DESC').page(params[:page]).per_page(10)
  end
  
  def new
    @video = Video.new
  end
  
  def edit
  end
  
  def create
    unless video_params[:code].blank?
      if video_params["video_type"] == "youtube"
        params[:video][:remote_image_url] = "http://img.youtube.com/vi/#{video_params[:code]}/0.jpg"
      elsif video_params["video_type"] == "vimeo"
        api_url = "http://vimeo.com/api/v2/video/#{video_params[:code]}.json"
        s = open(URI.escape(api_url)).read
        video_json = JSON.parse(s)
        params[:video][:remote_image_url] = video_json.first["thumbnail_large"]
      end
    end
    
    @video = Video.new(video_params)

    if @video.save
      redirect_to [:admin, :videos], notice: 'Video Creado Exitosamente.'
    else
      render action: "new"
    end
  end
  
  def update
    unless video_params[:code].blank?
      video = Video.find(params[:id].to_i)
      if !video.blank? && video.code != video_params[:code]
        if video_params["video_type"] == "youtube"
          params[:video][:remote_image_url] = "http://img.youtube.com/vi/#{video_params[:code]}/0.jpg"
        elsif video_params["video_type"] == "vimeo"
          api_url = "http://vimeo.com/api/v2/video/#{video_params[:code]}.json"
          s = open(URI.escape(api_url)).read
          video_json = JSON.parse(s)
          params[:video][:remote_image_url] = video_json.first["thumbnail_large"]
        end
      end
    end
    
    if @video.update_attributes(video_params)
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
  
  def video_params
    params.require(:video).permit :name, :code, :image, :remote_image_url, :outstanding, :video_type
  end
end
