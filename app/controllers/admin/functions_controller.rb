# encoding: utf-8
require 'nokogiri'
require 'http'

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
    
    @functions = @theater.functions.includes(:show, :showtimes, :function_types)
    .where(date: params[:date]).references(:show, :showtimes, :function_types)
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
      parse_cineplanet parse_days, parse_detector_types
    else
      redirect_to [:admin, :cinemas], alert: "operación no habilitada para #{@theater.name}"
    end
  end
  
  def save_update_parsed_show show_id, parsed_show_id, parsed_show_show_id
    if parsed_show_show_id.blank?
      parsed_show = ParsedShow.find(parsed_show_id)
      parsed_show.show_id = show_id
      parsed_show.save
    elsif parsed_show_show_id != show_id
      parsed_show = ParsedShow.find(parsed_show_id)
      parsed_show.show_id = show_id
      parsed_show.save
    end
  end
  
  # CREATE PARSE
  def create_parse
    @theater = Theater.find(params[:theater_id])
    cinema_name = @theater.cinema.name
    is_cineplanet = params[:is_cineplanet]
    
    if cinema_name == "Cinemark" || cinema_name == "Cine Hoyts" || cinema_name == "Cinemundo" || cinema_name == "Cineplanet"
      functions_to_save = []
      count = 0
      while hash = params["movie_#{count}"]
        unless hash[:show_id].blank?
          count2 = 0
          save_update_parsed_show hash[:show_id], hash[:parsed_show_id], hash[:parsed_show_show_id]
          while hash2 = hash["function_#{count2}"]
            if hash2[:horarios].size >= 5
              function = @theater.functions.new
              function.show_id = hash[:show_id].to_i
              function.function_type_ids = hash[:function_types]
              function.date = hash2[:date]
              Function.create_showtimes function, hash2[:horarios]
              functions_to_save << function
              # function.save
            end
            count2 = count2 + 1
          end
        end
        count = count + 1
      end
      @theater.override_functions functions_to_save, params[:date].to_date, params[:parse_days_count]
    end
    redirect_to admin_theater_functions_path(date: params[:date]), notice: "Exito"
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
    params.require(:function).permit :theater_id, :show_id, :date, showtimes_ids: [], function_type_ids: []
  end

  def prepare_for_new_parse
    @theater = Theater.find(params[:theater_id])
    @cinema = @theater.cinema
    @function_types = @cinema.function_types.order(:name)
    @shows = Show.order(:name).select('shows.id, shows.name')
    parse_params = params[action_name.to_sym]
    @date = parse_params[:date].to_date if parse_params[:date]
    parse_days = []
    if parse_params[:parse_type] == 'week'
      if @date.wday <= 3
        parse_days = (@date..@date.next_day(3 - @date.wday)).to_a
      else
        parse_days = (@date..@date.next_week(:wednesday)).to_a
      end
    else
      parse_days << @date
    end
    parse_detector_types = @cinema.parse_detector_types
    
    [parse_days, parse_detector_types]
  end
  
  def parse_cinemark(parse_days, parse_detector_types)
    url = @theater.web_url
    s = open(url).read
    s.gsub!('&nbsp;', ' ') 
    page = Nokogiri::HTML(s) 
    
    @functionsArray = []

    page.css('div.movie-list-inner').each_with_index do |item, index|
      
      detected_function_types = []
      titulo = item.css('h3 span').text
      
      parsed_show_name = titulo.gsub(" ","")
      
      item.css('div.version-types-wrap span').each do |item, index|
        pdt = parse_detector_types.detect{ |p| p.name == item.text }
        unless pdt.blank?
          detected_function_types << pdt.function_type_id
          titulo.prepend("(#{pdt.name})-")
        end
      end
      
      parse_detector_types.each do |pdt|
        next if detected_function_types.include?(pdt.function_type_id)
        if titulo.include?(pdt.name)
          detected_function_types << pdt.function_type_id
          titulo.prepend("(#{pdt.name})-")

          # Remove the Movie Type from the Parsed Show Name
          # Parsed Show Name is gonna be used to detect the movie in the database.
         parsed_show_name.gsub!(pdt.name, "")
        end
      end

       parsed_show_name.gsub!(/\(|\)|\s/, "")
               
      parsed_show = ParsedShow.select('id, show_id').find_or_create_by(name: parsed_show_name[0..10])

      movieFunctions = Hash[:name, titulo]
      movieFunctions[:parsed_show] = Hash[:id, parsed_show.id]
      movieFunctions[:parsed_show][:show_id] = parsed_show.show_id
      movieFunctions[:function_types] = detected_function_types
      movieFunctions[:functions] = []
      
      item.css('li.showtime-item').each_with_index do |item, index|
        diaArray = item.css('span.showtime-day').text.split("-") # => ["14","jun:"]
        dia = diaArray[0].to_i
        
        if parse_days.map(&:day).include?(dia)
          function = Hash[:day, diaArray.join("-")]
          
          horarios = ""
          item.css('span.showtime-hour').each do |item, index|
            horarios << "#{item.text}, "
          end
          function[:horarios] = horarios
          function[:date] = @date.advance_to_day(dia)
          movieFunctions[:functions] << function
        end
      end
      @functionsArray << movieFunctions if movieFunctions[:functions].count > 0
    end
  end
  
  def parse_hoyts(parse_days, parse_detector_types)
    @functionsArray = []
    function_helper = nil
    
    parse_days.each do |parse_day|
      
      date_hoyts = parse_day.strftime("%d-%m-%Y")
      url = "#{@theater.web_url}&fecha=#{date_hoyts}"
      s = open(url).read
      s.gsub!('&nbsp;', ' ')
      page = Nokogiri::HTML(s)

      page.css('table[width="440"] tr').each_with_index do |tr, index|
        if index % 2 == 0
          function_helper = nil
          titulo = tr.css('td[width="241"] span').text.split.join(' ')
          if titulo
            # search if the same movie has been read on a previous date:
            @functionsArray.each_with_index do |item, index|
              if item[:name] == titulo
                function_helper = item
                break
              end
            end
            if function_helper == nil
              function_helper = Hash[:name, titulo]
              function_helper[:functions] = []
              detected_function_types = []
              
              parsed_show_name = titulo.gsub(" ","")
              
              parse_detector_types.each do |pdt|
                if titulo.include?(pdt.name)
                  detected_function_types << pdt.function_type_id
                end
                parsed_show_name = parsed_show_name.gsub(pdt.name, "")
              end
              
              parsed_show = ParsedShow.select('id, show_id').find_or_create_by(name: parsed_show_name[0..10])
              function_helper[:parsed_show] = Hash[:id, parsed_show.id]
              function_helper[:parsed_show][:show_id] = parsed_show.show_id
              
              function_helper[:function_types] = detected_function_types
              
              @functionsArray << function_helper
            end
          end
        else
          if tr.css('td[width="241"] font[color="white"]')
            horarios = tr.css('td[width="241"] font[color="white"]').text.gsub!(/\s+/, ' ')
            function = Hash[:date, parse_day.to_s]
            function[:horarios] = horarios
            function_helper[:functions] << function
          end
        end
      end
    end
  end
  
  def parse_cineplanet(parse_days, parse_detector_types)
    theater_name = @theater.name
    url = "http://www.cineplanet.cl/"
    unless url.blank?
      proxy_ip = Settings.proxy.split(':')[0]
      proxy_port = Settings.proxy.split(':')[1]
      s = HTTP.via(proxy_ip, proxy_port.to_i).get(url).to_s
      s.gsub!('&nbsp;', ' ') 
      page = Nokogiri::HTML(s)

      @functionsArray = []

      page.css('#lista-pelicula div.img a').each_with_index do |item, index|
  
        url2 = item[:href]
        s2 = HTTP.via(proxy_ip, proxy_port.to_i).get(url2).to_s
        s2.gsub!('&nbsp;', ' ') 
        page2 = Nokogiri::HTML(s2) 
    
        pelicula = page2.css('div[class="superior titulo-tamano-superior-modificado"]')
        next if pelicula == nil
        pelicula = pelicula.text.split.join(' ')
        
        parsed_show_name = pelicula.gsub(" ","")
        
        detected_function_types = []
        parse_detector_types.each do |pdt|
          next if detected_function_types.include?(pdt.function_type_id)
          if pelicula.include?(pdt.name)
            detected_function_types << pdt.function_type_id
            pelicula.prepend("(#{pdt.name})-")
            parsed_show_name.gsub!(pdt.name, "")
          end
        end
      
        parsed_show = ParsedShow.select('id, show_id').find_or_create_by(name: parsed_show_name[0..10])
        
        movieFunctions = {name: pelicula}
        movieFunctions[:parsed_show] = {id: parsed_show.id}
        movieFunctions[:parsed_show][:show_id] = parsed_show.show_id
        movieFunctions[:function_types] = detected_function_types
        movieFunctions[:functions] = []
        
        theater_found = false
        page2.css("div.contenedor-lista-peliculas2 div.texto-lista").each_with_index do |div, index|
          strong = div.css("strong").text
          # si strong.empty?, entonces se está en los horarios
          if strong.empty? && theater_found
            if spans = div.css('span.flotar-izquierda')
          
              date_array = spans[0].text.split
              dia = date_array[1].to_i
              
              if parse_days.map(&:day).include?(dia)
                horarios = spans[1].text.gsub(/\s{3,}/, ", ")
                function = Hash.new
                function[:day] = date_array.to_s
                function[:horarios] = horarios
                function[:date] = @date.advance_to_day dia
                movieFunctions[:functions] << function
              end
            end
          else
            break if theater_found
            if strong == theater_name
              theater_found = true
            end
          end
        end
        @functionsArray << movieFunctions if movieFunctions[:functions].count > 0
      end
      
    else
      redirect_to [:admin, :cinemas], alert: "URL inválida" 
    end
  end
end
