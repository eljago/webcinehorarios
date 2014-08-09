#!/bin/env ruby
# encoding: utf-8
class Admin::ShowsController < ApplicationController
  
  before_filter :get_show, only: :destroy
  
  def index
    # letter = params[:letter].blank? ? 'A' : params[:letter] 
    # @shows = Show.where('name like ?', "#{letter}%").order(:name).all
    @shows = Show.text_search(params[:query]).paginate(page: params[:page], per_page: 10)
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
    @people = Person.select([:id, :name]).order('people.name ASC').all
  end
  
  def edit
    @show = Show.includes(:show_person_roles => :person).order('show_person_roles.position').find(params[:id])
    @people = Person.select([:id, :name]).order('people.name ASC').all
  end
  
  def create
    if params[:show][:videos_attributes]
      params[:show][:videos_attributes].each do |key, video|
        unless video[:code].blank?
          video[:remote_image_url] = "http://img.youtube.com/vi/#{video[:code]}/0.jpg"
        end
      end
    end
    @show = Show.new(params[:show])
    
    if @show.save
      @show.images.each do |image|
        if image.show_portrait_id == 0
          image.show_portrait_id = nil
          image.save
        elsif image.show_portrait_id == 1
          image.show_portrait_id = @show.id
          image.save
        end
      end
      redirect_to admin_shows_url(letter: @show.name[0].upcase), notice: 'Show was successfully created.'
    else
      @people = Person.select([:id, :name]).order('people.name ASC').all
      render action: "new"
    end
  end
  
  def update
    @show = Show.find(params[:id])
    if params[:show][:videos_attributes]
      params[:show][:videos_attributes].each do |key, video|
        unless video[:code].blank?
          db_video = @show.videos.where(id: video[:id].to_i)
          unless db_video && db_video.code == video[:code]
            video[:remote_image_url] = "http://img.youtube.com/vi/#{video[:code]}/0.jpg"
          end
        end
      end
    end
    
    if @show.update_attributes(params[:show])
      @show.images.each do |image|
        if image.show_portrait_id == 0
          image.show_portrait_id = nil
          image.save
        elsif image.show_portrait_id == 1
          image.show_portrait_id = @show.id
          image.save
        end
      end
      redirect_to admin_shows_url(letter: @show.name[0].upcase), notice: 'Show was successfully updated.'
    else
      @people = Person.select([:id, :name]).order('people.name ASC').all
      render action: "edit"
    end
  end
  
  def destroy
    @show.destroy
    redirect_to [:admin, :shows]
  end
  
  def get_show
    @show = Show.find(params[:id])
  end
  
  def billboard
    date = Date.current
    @shows = Show.joins(:functions).where(active: true, functions: {date: date})
    .select('shows.id, shows.name, shows.duration, shows.name_original, shows.image, shows.debut, shows.rating, shows.slug')
    .order("debut DESC").uniq.all
  end
  
  def comingsoon
    date = Date.current
    @shows = Show.where('(debut > ? OR debut IS ?) AND active = ?', date, nil, true)
    .select('shows.id, shows.name, shows.duration, shows.name_original, shows.image, shows.debut, shows.rating, shows.slug')
    .order("debut ASC").all
  end
  
end
