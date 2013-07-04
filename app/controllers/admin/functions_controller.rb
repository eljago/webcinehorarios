#!/bin/env ruby
# encoding: utf-8

class Admin::FunctionsController < ApplicationController
  require 'nokogiri'
  
  before_filter :get_theater, only: [:new, :create, :copy_last_day, :delete_day]
  before_filter :get_function, only: [:edit, :update, :destroy]
  
  def index
    @dates_array = (Date.current..(Date.current+7))
    
    if params[:date].blank? || !@dates_array.include?(DateTime.parse(params[:date]).to_date)
      params[:date] = Date.current
    else
      params[:date] = DateTime.parse(params[:date]).to_date
    end
    @theater = Theater.find(params[:theater_id])
    
    @functions = @theater.functions.includes(:show, :showtimes, :function_types)
    .where('date = ?',params[:date])
    .order("functions.created_at, showtimes.time")
  end
  
  def new
    @function = @theater.functions.new
  end
  
  def edit
  end
  
  def create
    @function = @theater.functions.new(params[:function])
    Function.create_showtimes @function, params[:horarios]
    Function.create_extra_showtimes_from_params @function, @theater
    
    if params[:horarios].blank?
      redirect_to admin_theater_functions_path(date: @function.date), notice: 'Funciones creadas con exito, pero en el día actual no.'
    else
      if @function.save
        redirect_to admin_theater_functions_path(date: @function.date), notice: 'Funciones creadas con exito.'
      else
        render action: "new"
      end
    end
  end
  
  def update
    @function.assign_attributes(params[:function])
    if (params[:horarios].gsub(/\s{3,}|( - )|(, )/, ", ") != @function.showtimes.map{ |showtime| l(showtime.time, format: :normal_time ) }.join(', '))
      @function.showtimes = []
      Function.create_showtimes @function, params[:horarios]
    end
    
    if @function.save
      redirect_to admin_theater_functions_path(date: @function.date), notice: 'funcion actualizada con exito.'
    else
      render action: "edit"
    end
  end
  
  def destroy
    @function.destroy

    redirect_to admin_theater_functions_path(date: params[:date] )
  end
  
  def copy_last_day
    date = Function.where('theater_id = ?',params[:theater_id]).order('date ASC').all.last.date
    functions = Function.where('theater_id = ? AND date = ?',params[:theater_id],date)
    functions.each do |function|
      func = function.dup
      func.function_types = function.function_types
      func.showtimes = function.showtimes
      func.date = function.date.next
      func.save
    end
    redirect_to admin_theater_functions_path(date: date.tomorrow ), notice: 'Dia copiado con exito.'
  end
  
  def delete_day
    puts 'testing'
    functions = Function.where(date: params[:date], theater_id: params[:theater_id])
    functions.each do |function|
      function.destroy
    end
    redirect_to admin_theater_functions_path(date: params[:date])
  end

  # GET DATOS DE LA WEB
  def new_parse
    @theater = Theater.find(params[:theater_id])
    @function_types = FunctionType.order(:name).all
    @shows = Show.order(:name).select('shows.id, shows.name').all
    @date = params[:date] if params[:date]
    if @theater.cinema.id == 2 || @theater.cinema.id == 1 || 
      (Rails.env.production? && @theater.cinema.id == 4) || (Rails.env.development? && @theater.cinema.id == 3)
      
      parse_cine @theater.cinema.id
    elsif (Rails.env.production? && @theater.cinema.id == 3) || (Rails.env.development? && @theater.cinema.id == 4)
      @date = params[:new_parse][:date]
      parse_cine @theater.cinema.id
    else
      redirect_to [:admin, :cinemas], alert: "operación no habilitada para #{@theater.cinema.name}"
    end
  end
  def create_parse
    @theater = Theater.find(params[:theater_id])
    
    if @theater.cinema.id == 1 || @theater.cinema.id == 2 || (Rails.env.production? && @theater.cinema.id == 4) || (Rails.env.development? && @theater.cinema.id == 3)
      count = 0
      while hash = params["movie_#{count}"]
        count2 = 0
        while hash2 = hash["function_#{count2}"]
          if hash2[:horarios].size >= 5
            function = @theater.functions.new
            function.show_id = hash[:show_id]
            function.function_type_ids = hash[:function_types]
            function.date = hash2[:date]
            Function.create_showtimes function, hash2[:horarios]
            function.save
          end
          count2 = count2 + 1
        end
        count = count + 1
      end
    elsif (Rails.env.production? && @theater.cinema.id == 3) || (Rails.env.development? && @theater.cinema.id == 4)
      count = 0
      while hash = params[:theaters]["theater_#{count}"]
        count2 = 0
        theater = Theater.find(hash[:theater_id])
        while hash2 = hash["function_#{count2}"]
          if hash2[:horarios].size >= 5
            function = theater.functions.new
            function.show_id = params[:show_id]
            function.function_type_ids = params[:function_types][:function_types]
            function.date = hash2[:date]
            Function.create_showtimes function, hash2[:horarios]
            function.save
          end
          count2 = count2 + 1
        end
        count = count + 1
      end
    end
    redirect_to admin_theater_functions_path(date: params[:date]), notice: "Exito"
  end
  
  private
  
  def get_function
    @function = Function.find(params[:id])
    @theater = @function.theater
  end
  
  def get_theater
    @theater = Theater.find(params[:theater_id])
  end
  
  
  
  # GET DATOS DE LA WEB Y SETEA FUNCTIONSARRAY PARA ARMAR EL VIEW THEATERS/XX/NEW_PARSE.HTML.ERB
  def parse_cine cod
    case
      # CINEMARK
    when 1 == cod
      if !@theater.web_label.blank? && @date
        url = "http://www.cinemark.cl/DetalleCine.aspx?cinema=#{@theater.web_label}"
        s = open(url).read
        s.gsub!('&nbsp;', ' ') 
        page = Nokogiri::HTML(s) 
        
        @functionsArray = []

        page.css('div.box_middle div[class="c73l bold h18"]').each_with_index do |item, index|

          date = @date.to_date
          
          function_types = []
          titulo = item.text.gsub!(/\s+/, ' ')[0..50]
          img = item.css('img[alt="Sala Premium"]')
          unless img.blank?
            function_types << find_function_type_id(@function_types, "Premier")
            titulo.prepend("(Premier)-")
          end
          img = item.css('img[alt="Película 3D"]')
          unless img.blank?
            function_types << find_function_type_id(@function_types, "3D")
            titulo.prepend("(3D)-")
          end
          img = item.css('img[alt="Sala XD"]')
          unless img.blank?
            function_types << find_function_type_id(@function_types, "Sala XD")
            titulo.prepend("(Sala XD)-")
          end
          function_types << find_function_type_id(@function_types, "Subtitulada") if ((titulo.include? "(Subtitulada)") || (titulo.include? "(Sub)"))
          function_types << find_function_type_id(@function_types, "Doblada") if ((titulo.include? "(Doblada)") || (titulo.include? "(Dob)"))
          function_types << find_function_type_id(@function_types, "2D") if titulo.include? "2D"
          function_types << find_function_type_id(@function_types, "Premier") if ((titulo.include? "PR") && !function_types.include?(find_function_type_id(@function_types, "Premier")))

          movieFunctions = Hash[:name, titulo]
          movieFunctions[:function_types] = function_types
          
          movieFunctions[:functions] = []

          item.css('tr').each do |tr|
            tds = tr.css('td')
            diaArray = tds[0].css('strong').text.split("-") # => ["14","jun:"]
            dia = diaArray[0].to_i

            unless (1..9).include? (date.day - dia)
              horarios = tds[1].text.gsub!(/\s+/, ', ')
              
              function = Hash[:day, diaArray.join("-")]
              function[:horarios] = horarios
              
              function[:date] = date.advance_to_day(dia)
              movieFunctions[:functions] << function
            end
          end
          @functionsArray << movieFunctions
        end
      else
        redirect_to [:admin, :cinemas], alert: "falta web label o date"
      end
    
      # CINE HOYTS
    when cod == 2 || (Rails.env.production? && cod == 4) || (Rails.env.development? && cod == 3)
      if !@theater.web_label.blank? && @date
        date = @date.to_date
        times = 8 - (date - Date.current).to_i
        @functionsArray = []
        function_helper = nil
        
        times.times do |n| # LOOP START
          
          date_hoyts = date.to_s.split("-").reverse.join("-")
          url = "http://www.cinehoyts.cl/?mod=#{@theater.web_label}&fecha=#{date_hoyts}"
          s = open(url).read
          s.gsub!('&nbsp;', ' ')
          page = Nokogiri::HTML(s)

          page.css('table[width="440"] tr').each_with_index do |tr, index|
            if index % 2 == 0
              function_helper = nil
              text_name = tr.css('td[width="241"] span')
              if text_name
                text_name_with_spaces = text_name.text.gsub!(/\s+/, ' ')
                if text_name_with_spaces
                  titulo = text_name_with_spaces
                else
                  titulo = text_name.text
                end
                @functionsArray.each_with_index do |item, index|
                  if item[:name] == titulo
                    function_helper = item
                    break
                  end
                end
                if function_helper == nil
                  function_helper = Hash[:name, titulo]
                  function_helper[:functions] = []
                  function_types = []
                  function_types << find_function_type_id(@function_types, "Español") if text_name.text.include? '(ESP)'
                  function_types << find_function_type_id(@function_types, "Subtitulada") if text_name.text.include? '(SUBT)'
                  function_types << find_function_type_id(@function_types, "3D") if text_name.text.include? '3D'
                  function_types << find_function_type_id(@function_types, "Premium") if text_name.text.include? 'PREMIUM'
                  function_helper[:function_types] = function_types
                  
                  @functionsArray << function_helper
                end
              end
            else
              if tr.css('td[width="241"] font[color="white"]')
                horarios = tr.css('td[width="241"] font[color="white"]').text.gsub!(/\s+/, ' ')
                function = Hash[:date, date.to_s]
                function[:horarios] = horarios
                function_helper[:functions] << function
              end
            end
          end
          
          date = date.next
        end # END LOOP
      else
        redirect_to [:admin, :cinemas], alert: "falta web label o date"
      end
    
      # CINEPLANET
    when (Rails.env.production? && cod == 3) || (Rails.env.development? && cod == 4)
      if @date && url = params[:new_parse][:url]
        s = open(url).read
        s.gsub!('&nbsp;', ' ') 
        page = Nokogiri::HTML(s)
        
        @functionsArray = []
        date = @date.to_date
        
        @name_pelicula = page.css('div[class="superior titulo-tamano-superior-modificado"]').text
        @function_types_detected = []
        @function_types_detected << find_function_type_id(@function_types, "Subtitulada") if @name_pelicula.include? "Subtitulada"
        @function_types_detected << find_function_type_id(@function_types, "Doblada") if ((@name_pelicula.include? "Doblada") || (@name_pelicula.include? "Doblado"))
        @function_types_detected << find_function_type_id(@function_types, "3D") if @name_pelicula.include? "3D"
        @function_types_detected << find_function_type_id(@function_types, "Prime") if @name_pelicula.include? "PRIME"
        @function_types_detected << find_function_type_id(@function_types, "HD") if @name_pelicula.include? "HD"
        
        
        name = ""
        count = -1
        lista = page.css("div.contenedor-lista-peliculas2 div.texto-lista").each_with_index do |div, index|
          strong = div.css("strong").text
          if strong.blank?
            if spans = div.css('span.flotar-izquierda')
              
              dia = spans[0].text.split(" ").last.to_i
              horarios = spans[1].text.gsub(/\s{3,}|( - )|(, )/, "a").split("a").join(", ")
              unless (1..9) === (date.day - dia)
                @functionsArray[count][:functions] << { date: date.advance_to_day(dia), horarios: horarios }
              end
            end
          else
            count = count + 1
            name = strong
            @functionsArray << { theater: name, functions: [] }
          end
        end
      end
    else
      redirect_to [:admin, :cinemas], alert: "operacion inválida para #{@theater.cinema.name}"
    end
  end
  
  def find_function_type_id function_types, name
    id = 0
    function_types.each do |item|
      if item.name == name
        id = item.id
        break
      end
    end
    id
  end
  
end
