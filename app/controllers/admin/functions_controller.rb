# encoding: utf-8

class Admin::FunctionsController < ApplicationController
  before_filter :get_theater, only: [:index, :new, :create, :copy_last_day, :delete_day, :delete_week]
  before_filter :get_function, only: [:edit, :update, :destroy]

  def index
    @dates_array = ((Date.current-2)..(Date.current+7))

    if params[:date].blank? || !@dates_array.include?(params[:date].to_date)
      params[:date] = Date.current
    else
      params[:date] = params[:date]
    end

    @functions = @theater.functions.includes(:show, :showtimes, :function_types, :parsed_show => :show)
    .where(date: params[:date]).references(:showtimes)
    .order("functions.show_id DESC, showtimes.time ASC")
  end

  def new
    @function = @theater.functions.new
    @shows = Show.select([:id, :name]).order('shows.name ASC')
  end

  def edit
    @shows = Show.select([:id, :name]).order('shows.name ASC')
  end

  def create
    @function = @theater.functions.new(function_params)
    Function.create_showtimes @function, params[:horarios]
    Function.create_extra_showtimes_from_params @function, @theater, params

    if params[:horarios].blank?
      redirect_to admin_theater_functions_path(date: @function.date), notice: 'Funciones creadas con exito, pero en el día actual no.'
    else
      if @function.save
        redirect_to admin_theater_functions_path(date: @function.date), notice: 'Funciones creadas con exito.'
      else
        params[:date] = @function.date
        render action: "new"
      end
    end
  end

  def update
    @function.assign_attributes(function_params)
    if (Function.create_string_from_horarios(params[:horarios]) != @function.showtimes.map{ |showtime| l(showtime.time, format: :normal_time ) }.join(', '))
      @function.showtimes = []
      Function.create_showtimes @function, params[:horarios]
    end

    if @function.save
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
        function.showtimes.order('time ASC').each do |showtime|
          showt = showtime.dup
          func.showtimes << showt
        end
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


  # PARSED SHOWS INDEX
  def orphan_parsed_shows
    parsed_shows1 = ParsedShow.where(show_id: nil).select(:id, :name, :show_id)
    parsed_shows2 = ParsedShow.joins(:functions).where('functions.show_id IS ?', nil).uniq

    @parsed_shows = parsed_shows1 | parsed_shows2

    @shows = Show.select([:id, :name]).order('shows.name ASC')
  end
  # PARSED SHOWS CREATE PARSED SHOWS
  def create_parsed_shows

    parsed_shows_updated_count = 0
    functions_updated_count = 0
    destroyed_count = 0
    functions_destroyed_count = 0

    count = 0
    while hash = params["orphan_parsed_shows_#{count}"]
      parsed_show = ParsedShow.find(hash[:parsed_show_id])
      if hash[:destroy].to_i == 1
        parsed_show.destroy
        parsed_show.functions.each do |f|
          f.destroy
          functions_destroyed_count = functions_destroyed_count + 1
        end
        destroyed_count = destroyed_count + 1
      elsif hash[:show_id].present?
        parsed_show.show_id = hash[:show_id]
        parsed_show.functions.where('functions.show_id IS ?', nil).each do |function|
          function.show_id = hash[:show_id]
          function.save
          functions_updated_count = functions_updated_count + 1
        end
        parsed_show.save
        parsed_shows_updated_count = parsed_shows_updated_count + 1
      end
      count = count + 1
    end

    redirect_to admin_orphan_parsed_shows_path, notice: "Actualizados #{parsed_shows_updated_count} parsed shows, #{functions_updated_count} functiones. #{destroyed_count} Parsed Shows destruidos. #{functions_destroyed_count} Funciones destruidas."
  end
  # PARSED SHOWS DESTROY ALL PARSED SHOWS
  def destroy_all_parsed_shows
    ParsedShow.destroy_all
    redirect_to admin_orphan_parsed_shows_path, notice: 'Destruidos'
  end


  private

  def get_function
    @function = Function.find(params[:id])
    @theater = @function.theater
  end

  def get_theater
    @theater ||= Theater.find(params[:theater_id])
  end

  def function_params
    params.require(:function).permit :theater_id, :show_id, :date, :parsed_show_id, showtimes_ids: [], function_type_ids: []
  end

end
