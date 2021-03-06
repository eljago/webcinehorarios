#!/bin/env ruby
# encoding: utf-8
require 'open-uri'
require 'json'
class Admin::ShowsController < ApplicationController

  before_action :get_show, only: :destroy
  before_action :set_previous_url, only: [:index, :billboard, :comingsoon]

  def set_previous_url
    if action_name == 'index'
      session[:previous_url] = admin_shows_url
    elsif action_name == 'billboard'
      session[:previous_url] = billboard_admin_shows_url
    elsif action_name == 'comingsoon'
      session[:previous_url] = comingsoon_admin_shows_url
    else
      session[:previous_url] = admin_shows_url
    end
  end

  def index
    @title = 'Shows'
    @app_name = 'ShowsApp'
    @props = {}
    @prerender = false
    render file: 'react/render'
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
    genres = Genre.order(:name).all
    video_types = Video.video_types.keys.map { |vt| {value: vt, label: vt} }
    countries = Country.order(:name).all

    @title = 'Nuevo Show'
    @app_name = 'ShowEditApp'
    @props = {
      show: Show.new,
      defaultShowPersonRole: ShowPersonRole.new,
      defaultVideo: Video.new,
      defaultImage: Image.new,
      genres: genres,
      videoTypes: video_types,
      countries: countries
    }
    @prerender = false
    render file: 'react/render'
  end

  def edit
    show = Show.includes(:show_person_roles)
      .order('show_person_roles.position').find(params[:id])
    hash_show = show.as_json
    hash_show["genres"] = show.genre_ids
    hash_show["countries"] = show.country_ids
    hash_show["show_person_roles"] = show.show_person_roles.includes(:person).order(:position).map do |spr|
      {
        "id" => spr.id,
        "person_id" => spr.person_id,
        "name" => spr.person.present? ? spr.person.name : '',
        'image' => spr.person.present? ? spr.person.image.as_json[:image] : '',
        "actor" => spr.actor,
        "director" => spr.director,
        "character" => spr.character,
        "position" => spr.position
      }
    end
    hash_show["images"] = show.images.order('images.created_at').map do |img|
      {
        "id" => img.id,
        "image" => img.image.as_json[:image],
        "poster" => img.poster,
        "backdrop" => img.backdrop
      }
    end
    hash_show["videos"] = show.videos.order('videos.created_at').map do |video|
      {
        "id" => video.id,
        "name" => video.name,
        "code" => video.code,
        "video_type" => video.video_type,
        "image" => video.image,
        "outstanding" => video.outstanding
      }
    end
    genres = Genre.order(:name).all
    video_types = Video.video_types.keys.map { |vt| {value: vt, label: vt} }
    countries = Country.order(:name).all

    @title = show.name
    @app_name = 'ShowEditApp'
    @props = {
      show: hash_show,
      defaultShowPersonRole: ShowPersonRole.new,
      defaultVideo: Video.new,
      defaultImage: Image.new,
      genres: genres,
      videoTypes: video_types,
      countries: countries
    }
    @prerender = false
    render file: 'react/render'
  end

  def create
    new_show_params = show_params
    if new_show_params[:videos_attributes]
      new_show_params[:videos_attributes].each do |key, video|
        unless video[:code].blank?
          if video["video_type"] == "youtube"
            video[:remote_image_url] = "http://img.youtube.com/vi/#{video[:code]}/0.jpg"
          elsif video["video_type"] == "vimeo"
            api_url = "http://vimeo.com/api/v2/video/#{video[:code]}.json"
            s = open(URI.escape(api_url)).read
            video_json = JSON.parse(s)
            video[:remote_image_url] = video_json.first["thumbnail_large"]
          end
        end
      end
    end
    @show = Show.new(new_show_params)

    if @show.save
      redirect_to session[:previous_url], notice: 'Show was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @show = Show.friendly.find(params[:id])
    instance_show_params = show_params
    if instance_show_params[:videos_attributes]
      instance_show_params[:videos_attributes].each do |key, video|
        if video[:code].present?
          if key.to_i > 2147483647

            if video["video_type"] == "youtube"
              video[:remote_image_url] = "http://img.youtube.com/vi/#{video[:code]}/0.jpg"
            elsif video["video_type"] == "vimeo"
              api_url = "http://vimeo.com/api/v2/video/#{video[:code]}.json"
              s = open(URI.escape(api_url)).read
              video_json = JSON.parse(s)
              video[:remote_image_url] = video_json.first["thumbnail_large"]
            end
          elsif video[:_destroy] == "false"
            db_video = @show.videos.find(video[:id].to_i)
            unless db_video && db_video.code == video[:code]
              if video["video_type"] == "youtube"
                video[:remote_image_url] = "http://img.youtube.com/vi/#{video[:code]}/0.jpg"
              elsif video["video_type"] == "vimeo"
                api_url = "http://vimeo.com/api/v2/video/#{video[:code]}.json"
                s = open(URI.escape(api_url)).read
                video_json = JSON.parse(s)
                video[:remote_image_url] = video_json.first["thumbnail_large"]
              end
            end
          end
        end
      end
    end

    if @show.update_attributes(instance_show_params)
      redirect_to session[:previous_url], notice: 'Show was successfully updated.'
    else
      @people = Person.select([:id, :name]).order('people.name ASC')
      render action: "edit"
    end
  end

  def destroy
    @show.destroy
    redirect_to session[:previous_url]
  end

  def billboard
    date = Date.current
    @shows = Show.joins(:functions).where(active: true, functions: {date: date})
    .select('shows.id, shows.name, shows.duration, shows.name_original, shows.debut, shows.rating, shows.slug')
    .order("debut DESC").uniq
  end

  def comingsoon
    date = Date.current
    @shows = Show.where('(debut > ? OR debut IS ?) AND active = ?', date, nil, true)
    .select('shows.id, shows.name, shows.duration, shows.name_original, shows.debut, shows.rating, shows.slug')
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
    params.require(:show).permit :active, :year, :debut, :name, :information, :duration, :name_original, :rating, :metacritic_url, :metacritic_score, :imdb_code, :imdb_score, :rotten_tomatoes_url, :rotten_tomatoes_score, images_attributes: [ :_destroy, :id, :name, :image, :remote_image_url, :width, :height, :backdrop ], videos_attributes: [ :_destroy, :id, :name, :code, :image, :remote_image_url, :outstanding, :video_type ], show_person_roles_attributes: [ :_destroy, :id, :actor, :writer, :creator, :producer, :director, :person_id, :show_id, :character ], genre_ids: []
  end
end
