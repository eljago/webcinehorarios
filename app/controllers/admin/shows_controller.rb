#!/bin/env ruby
# encoding: utf-8
class Admin::ShowsController < ApplicationController
  
  before_filter :get_show, only: :destroy
  
  def index
    # letter = params[:letter].blank? ? 'A' : params[:letter] 
    # @shows = Show.where('name like ?', "#{letter}%").order(:name)
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
  end
  
  def edit
    @show = Show.includes(show_person_roles: :person).order('show_person_roles.position').find(params[:id])
  end
  
  def create
    if show_params[:videos_attributes]
      show_params[:videos_attributes].each do |key, video|
        unless video[:code].blank?
          video[:remote_image_url] = "http://img.youtube.com/vi/#{video[:code]}/0.jpg"
        end
      end
    end
    @show = Show.new(show_params)
    
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
      render action: "new"
    end
  end
  
  def update
    @show = Show.find(params[:id])
    instance_show_params = show_params
    if instance_show_params[:videos_attributes]
      instance_show_params[:videos_attributes].each do |key, video|
        if video[:code].present?
          if key.to_i > 2147483647
            video[:remote_image_url] = "http://img.youtube.com/vi/#{video[:code]}/0.jpg"
          elsif video[:_destroy] == "false"
            db_video = @show.videos.find(video[:id].to_i)
            unless db_video && db_video.code == video[:code]
              video[:remote_image_url] = "http://img.youtube.com/vi/#{video[:code]}/0.jpg"
            end
          end
        end
      end
    end
    if @show.update_attributes(instance_show_params)
      redirect_to admin_shows_url(letter: @show.name[0].upcase), notice: 'Show was successfully updated.'
    else
      @people = Person.select([:id, :name]).order('people.name ASC')
      render action: "edit"
    end
  end
  
  def destroy
    @show.destroy
    redirect_to [:admin, :shows]
  end
  
  def billboard
    date = Date.current
    @shows = Show.joins(:functions).where(active: true, functions: {date: date})
    .select('shows.id, shows.name, shows.duration, shows.name_original, shows.image, shows.debut, shows.rating, shows.slug')
    .order("debut DESC").uniq
  end
  
  def comingsoon
    date = Date.current
    @shows = Show.where('(debut > ? OR debut IS ?) AND active = ?', date, nil, true)
    .select('shows.id, shows.name, shows.duration, shows.name_original, shows.image, shows.debut, shows.rating, shows.slug')
    .order("debut ASC")
  end
  
  def select_shows
    q = params[:q].split.map(&:capitalize).join(" ")
    @shows = Show.select([:id, :name]).
                          where("name like :q", q: "%#{q}%").
                          order('name').order(:name)

    respond_to do |format|
      format.json { render json: {shows: @shows.map { |e| {id: e.id, text: "#{e.name}"} }} }
    end
  end
  def simple_show
    @show = Show.select([:id, :name]).find(params[:show_id])
    respond_to do |format|
      format.json { render json: {show: { id: @show.id, name: @show.name } } }
    end
  end
  
  private
  
  def get_show
    @show = Show.find(params[:id])
  end
  
  def show_params
    params.require(:show).permit :active, :year, :debut, :name, :image, :information, :duration, :name_original, :rating, :remote_image_url, :metacritic_url, :metacritic_score, :imdb_code, :imdb_score, :rotten_tomatoes_url, :rotten_tomatoes_score, images_attributes: [ :_destroy, :id, :name, :image, :remote_image_url, :width, :height, :show_portrait_id ], videos_attributes: [ :_destroy, :id, :name, :code, :image, :remote_image_url, :outstanding ], show_person_roles_attributes: [ :_destroy, :id, :actor, :writer, :creator, :producer, :director, :person_id, :show_id, :character ], genre_ids: []
  end
end
