# encoding: utf-8

class Admin::FunctionsController < ApplicationController
  before_action :get_theater, only: [:index, :new, :create, :copy_last_day, :delete_day, :delete_week]
  before_action :get_function, only: [:edit, :update, :destroy]

  def index
    function_types = @theater.cinema.function_types.order(:name).all
    default_function = @theater.functions.new

    offsetDays = params[:date].present? ? (params[:date].to_date - Date.current).to_i : 0

    @title = 'Functions'
    @app_name = 'FunctionsApp'
    @props = {
      function_types: function_types,
      default_function: default_function,
      theater: @theater,
      offsetDays: offsetDays
    }
    @prerender = false
    render file: 'react/render'
  end

  def new
    @function = @theater.functions.new
    @shows = Show.select([:id, :name]).order('shows.name ASC')
  end

  def edit
    function_types = @theater.cinema.function_types.order(:name).all
    default_function = Function.new

    shows = Show.joins(:functions).where('functions.date = ? AND functions.theater_id = ?', params[:date], @theater.id).order('shows.id DESC')

    shows_hash = shows.as_json
    shows_hash.each do |show_hash|
      show_hash["functions"] = Function.where(date: params[:date], theater_id: params[:theater_id], show_id: show_hash[:id])
        .includes(:function_types, :parsed_show).order(:id)
    end

    @title = 'Edit Functions'
    @app_name = 'Functions'
    @props = {shows: shows_hash, function_types: function_types, default_function: default_function}
    @prerender = false
    render file: 'react/render'
  end

  def create
    @function = @theater.functions.new(function_params)
    @function.showtimes = params[:horarios]
    date = @function.date
    7.times do |n|
      horarios = params["horarios_extra_#{n}"]
      date = date.next
      if horarios.size >= 5
        function = @theater.functions.new
        function.date = date
        function.function_types = @function.function_types
        function.show_id = @function.show_id
        function.showtimes = horarios
        function.save
      end
    end
    if @function.save
      redirect_to admin_theater_functions_path(date: @function.date), notice: 'Funciones creadas con exito.'
    else
      params[:date] = @function.date
      render action: "new"
    end
  end

  def update
    if @function.update_attributes(function_params)
      redirect_to admin_theater_functions_path(date: @function.date), notice: 'funcion actualizada con exito.'
    else
      params[:date] = @function.date
      render action: "edit"
    end
  end

  def destroy
    @function.destroy
    redirect_to admin_theater_functions_path(date: params[:date] )
  end

  # INDEX ACTION COPY LAST DAY
  def copy_last_day
    date = params[:date].to_date
    functions = @theater.functions.where('functions.date = ?', date)
    if @theater.functions.count > 0
      functions.each do |function|
        func = function.dup
        func.function_types = function.function_types
        func.date = function.date.next
        func.showtimes = function.showtimes
        func.save
      end
      redirect_to admin_theater_functions_path(date: date.tomorrow ), notice: 'Dia copiado con exito.'
    else
      redirect_to admin_theater_functions_path(date: date), alert: 'No hay funciones en este día'
    end
  end

  # INDEX ACTION DELETE DAY
  def delete_day
    functions = @theater.functions.where(date: params[:date])
    functions.each do |function|
      function.destroy
    end
    redirect_to admin_theater_functions_path(date: params[:date])
  end

  # INDEX ACTION DELETE WEEK
  def delete_week
    functions = @theater.functions.where('functions.date >= ?', params[:date])
    functions.each do |function|
      function.destroy
    end
    redirect_to admin_theater_functions_path(date: params[:date])
  end

  private

  def function_params
    params.require(:function).permit :theater_id, :show_id, :date, :parsed_show_id, function_type_ids: []
  end

  def get_function
    @function = Function.find(params[:id])
    @theater = @function.theater
  end

  def get_theater
    @theater ||= Theater.friendly.find(params[:theater_id])
  end

end
