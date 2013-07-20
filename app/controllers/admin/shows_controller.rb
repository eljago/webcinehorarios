#!/bin/env ruby
# encoding: utf-8
class Admin::ShowsController < ApplicationController
  
  before_filter :get_show, only: :destroy
  
  def index
    letter = params[:letter].blank? ? 'A' : params[:letter] 
    @shows = Show.where('name like ?', "#{letter}%")
    .order(:name).all
  end
  
  def show
    @show = Show.includes(:show_person_roles => :person).find(params[:id])
    @participants = { directores: @show.show_person_roles.where(director: true),
                      creadores: @show.show_person_roles.where(creator: true),
                      productores: @show.show_person_roles.where(producer: true),
                      escritores: @show.show_person_roles.where(writer: true),
                      actores: @show.show_person_roles.where(actor: true) }
  end
  
  def new
    @show = Show.new
  end
  
  def edit
    @show = Show.find(params[:id])
  end
  
  def create
    if params[:show][:videos_attributes]
      params[:show][:videos_attributes].each do |key, video|
        if video[:code] != ""
          video[:remote_image_url] = "http://img.youtube.com/vi/#{video[:code]}/0.jpg"
        end
      end
    end
    @show = Show.new(params[:show])
    if params[:create_facebook] && params[:create_facebook] == "1" && params[:show][:remote_image_url] != ""
      create_facebook
    end
    
    if @show.save
      redirect_to admin_shows_url(letter: @show.name[0].upcase), notice: 'Show was successfully created.'
    else
      render action: "new"
    end
  end
  
  def update
    @show = Show.find(params[:id])
    if params[:show][:videos_attributes]
      params[:show][:videos_attributes].each do |key, video|
        if video[:code] != ""
          db_video = @show.videos.find_by_id(video[:id].to_i)
          if !db_video || db_video.code != video[:code]
            video[:remote_image_url] = "http://img.youtube.com/vi/#{video[:code]}/0.jpg"
          end
        end
      end
    end
    
    if @show.update_attributes(params[:show])
      redirect_to admin_shows_url(letter: @show.name[0].upcase), notice: 'Show was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @show.destroy
    if (current_user.facebook.access_token != nil)
      graph = Koala::Facebook::API.new(current_user.facebook.get_page_access_token(469307943155757))
      graph.delete_object(@show.facebook_id) if @show.facebook_id
    end
    redirect_to [:admin, :shows]
  end
  
  def get_show
    @show = Show.find(params[:id])
  end
  
  def create_facebook
    if Rails.env.production?
      image_url = params[:show][:remote_image_url]
      mensaje = params[:show][:name]
      
      if (current_user.facebook.access_token != nil)
        graph = Koala::Facebook::API.new(current_user.facebook.get_page_access_token(ENV['FACEBOOK_CINEHORARIOS_PAGE_ID']))
        response = graph.put_picture("#{image_url}",
          { message: mensaje },ENV['FACEBOOK_CINEHORARIOS_ALBUM_ID'])
        @show.facebook_id = response["id"]
      end
    end
  end
  
end
