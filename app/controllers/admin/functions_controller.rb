# encoding: utf-8
include TheaterParserHelper
include ActiveSupport::Inflector

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
  
  def delete_day
    functions = @theater.functions.where(date: params[:date])
    functions.each do |function|
      function.destroy
    end
    redirect_to admin_theater_functions_path(date: params[:date])
  end
  
  def delete_week
    functions = @theater.functions.where('functions.date >= ?', params[:date])
    functions.each do |function|
      function.destroy
    end
    redirect_to admin_theater_functions_path(date: params[:date])
  end

  def parse_theater
    parse_data_array = prepare_for_new_parse
    parse_days = parse_data_array[0]
    parse_detector_types = parse_data_array[1]
    @parse_days_count = parse_days.length
    
    continue = nil
    if @cinema.name == "CineStar"
      hash = parse_cinestar(@theater.web_url, parse_days)
      continue = true
    elsif @cinema.name == "Cinemark"
      hash = parse_cinemark(@theater.web_url, parse_days, @date)
      continue = true
    elsif @cinema.name == "Cine Hoyts" || @cinema.name == "Cinemundo"
      hash = parse_cinehoyts(@theater.id)
      continue = true
    elsif @cinema.name == "Cineplanet"
      hash = parse_cineplanet(@theater.web_url, parse_days, @theater.name)
      continue = true
    elsif @theater.slug == 'cinemall-quilpue'
      hash = parse_cinemall_quilpue
      continue = true
    end
    
    @functionsArray = []
    if continue
      hash[:movieFunctions].each do |hash_movie_function|
        titulo = hash_movie_function[:name] #
        detected_function_types = []
        parsed_show_name = transliterate(titulo.gsub(/\s+/, "")).underscore
        
        movieFunctions = { name: titulo }
        parse_detector_types.each do |pdt|
          next if detected_function_types.include?(pdt.function_type_id)
          if titulo.include?(pdt.name)
            detected_function_types << pdt.function_type_id
            titulo.prepend("(#{pdt.name})-")

            # Remove the Movie Type from the Parsed Show Name
            # Parsed Show Name is gonna be used to detect the movie in the database.
           parsed_show_name.gsub!(transliterate(pdt.name.gsub(/\s+/, "")).underscore, "")
          end
        end
        parsed_show_name.gsub!(/[^a-z0-9]/i, '')
        parsed_show = ParsedShow.select('id, show_id').find_or_create_by(name: parsed_show_name)
        
        movieFunctions[:functions] = []
        movieFunctions[:parsed_show] = { id: parsed_show.id, show_id: parsed_show.show_id }
        movieFunctions[:function_types] = detected_function_types
        hash_movie_function[:functions].each do |hash_function|
          function = { day: hash_function[:day] }
          function[:horarios] = hash_function[:showtimes]
          function[:date] = @date.advance_to_day(hash_function[:dia])
          movieFunctions[:functions] << function if function[:horarios].length > 0
        end
        @functionsArray << movieFunctions if movieFunctions[:functions].length > 0
      end
    end
  end

  # GET DATOS DE LA WEB
  # NEW PARSE
  def new_parse
    parse_data_array = prepare_for_new_parse
    parse_days = parse_data_array[0]
    @parse_days_count = parse_days.length
    parse_detector_types = parse_data_array[1]
    if @cinema.name == "Cinemark"
      parse_cinemark parse_days, parse_detector_types
    elsif @cinema.name == "Cine Hoyts" || @cinema.name == "Cinemundo"
      parse_hoyts parse_days, parse_detector_types
    elsif @cinema.name == "Cineplanet"
      parse_cineplanet parse_days
    else
      redirect_to [:admin, :cinemas], alert: "operación no habilitada para #{@theater.name}"
    end
  end
  
  # CREATE PARSE
  def create_parse
    @theater = Theater.find(params[:theater_id])
    cinema_name = @theater.cinema.name
    is_cineplanet = params[:is_cineplanet]
    
    if ["Cinemark", "Cine Hoyts", "Cinemundo", "Cineplanet", "CineStar"].include?(cinema_name) || @theater.slug == 'cinemall-quilpue'
      functions_to_save = []
      count = 0
      while hash = params["movie_#{count}"]
        count2 = 0
        save_update_parsed_show hash[:show_id], hash[:parsed_show_id], hash[:parsed_show_show_id]
        while hash2 = hash["function_#{count2}"]
          if hash2[:horarios].size >= 5
            function = @theater.functions.new
            function.show_id = hash[:parsed_show_show_id].to_i if hash[:parsed_show_show_id]
            function.show_id = hash[:show_id].to_i if hash[:show_id]
            function.function_type_ids = hash[:function_types]
            function.date = hash2[:date]
            function.parsed_show_id = hash[:parsed_show_id].to_i
            Function.create_showtimes function, hash2[:horarios]
            functions_to_save << function
            # function.save
          end
          count2 = count2 + 1
        end
        count = count + 1
      end
      @theater.override_functions(functions_to_save, params[:date].to_date, params[:parse_days_count])
    end
    redirect_to admin_theater_functions_path(date: params[:date]), notice: "Exito"
  end
  
  def orphan_parsed_shows
    parsed_shows1 = ParsedShow.where(show_id: nil).select(:id, :name, :show_id)
    parsed_shows2 = ParsedShow.joins(:functions).where('functions.show_id IS ?', nil).uniq
    
    @parsed_shows = parsed_shows1 | parsed_shows2
    
    @shows = Show.select([:id, :name]).order('shows.name ASC')
  end
  def create_parsed_shows
    
    parsed_shows_updated_count = 0
    functions_updated_count = 0
    destroyed_count = 0
    
    count = 0
    while hash = params["orphan_parsed_shows_#{count}"]
      parsed_show = ParsedShow.find(hash[:parsed_show_id])
      if hash[:destroy].to_i == 1
        parsed_show.destroy
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

    redirect_to admin_orphan_parsed_shows_path, notice: "Actualizados #{parsed_shows_updated_count} parsed shows, #{functions_updated_count} functiones. #{destroyed_count} Parsed Shows Destruidos"
  end
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

  def prepare_for_new_parse
    @theater = Theater.find(params[:theater_id])
    @cinema = @theater.cinema
    @function_types = @cinema.function_types.order(:name)
    @shows = Show.order(:name).select('shows.id, shows.name')
    parse_params = params[action_name.to_sym]
    parse_type = parse_params[:parse_type]
    @date = parse_params[:date].to_date if parse_params[:date]
    parse_days = []
    if parse_type == 'week'
      if @date.wday <= 3
        parse_days = (@date..@date.next_day(3 - @date.wday)).to_a
      else
        parse_days = (@date..@date.next_week(:wednesday)).to_a
      end
    else
      parse_days << @date
    end
    parse_detector_types = @cinema.parse_detector_types.order('LENGTH(name) DESC')
    
    [parse_days, parse_detector_types]
  end
  
end
