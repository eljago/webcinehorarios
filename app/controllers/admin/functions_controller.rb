# encoding: utf-8

class Admin::FunctionsController < ApplicationController
  before_action :get_theater, only: [:index, :new, :create, :copy_last_day, :delete_day, :delete_week]
  before_action :get_function, only: [:edit, :update, :destroy]

  def index
    # @dates_array = ((Date.current-2)..(Date.current+7))

    # if params[:date].blank? || !@dates_array.include?(params[:date].to_date)
    #   params[:date] = Date.current
    # else
    #   params[:date] = params[:date]
    # end

    # @functions = @theater.functions.includes(:show, :function_types, :parsed_show => :show)
    # .where(date: params[:date]).order("functions.show_id DESC")
    theater = Theater.friendly.find(params[:theater_id])
    @title = "Funciones #{theater.name}"
    @app_name = 'FunctionsApp'
    @props = {theater: theater}
    @prerender = false
    render file: 'react/render'
  end

  def new
    @function = @theater.functions.new
    @shows = Show.select([:id, :name]).order('shows.name ASC')
  end

  def edit
    function_types = @theater.cinema.function_types.order(:name).all
    function_hash = @function.as_json
    function_hash["theater"] = @theater.as_json
    function_hash["show"] = @function.show.as_json
    function_hash["function_types"] = @function.function_type_ids
    @title = 'Edit Function'
    @app_name = 'FunctionEditApp'
    @props = {function: function_hash, function_types: function_types}
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
