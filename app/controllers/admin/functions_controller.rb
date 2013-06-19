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
    create_showtimes @function, params[:horarios]
    create_extra_showtimes_from_params
    
    if @function.save
      redirect_to admin_theater_functions_path(date: @function.date), notice: 'Funcion creada con exito.'
    else
      render action: "new"
    end
  end
  
  def update
    @function.assign_attributes(params[:function])
    if (params[:horarios].gsub(/\s{3,}|( - )|(, )/, ", ") != @function.showtimes.map{ |showtime| l(showtime.time, format: :normal_time ) }.join(', '))
      @function.showtimes = []
      create_showtimes @function, params[:horarios]
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
    if @theater.cinema.id == 2 || @theater.cinema.id == 1
      parse_cine @theater.cinema.id
    elsif (Rails.env.production? && @theater.cinema.id == 3) || (Rails.env.development? && @theater.cinema.id == 4)
      @date = params[:new_parse][:date]
      parse_cine 3
    else
      redirect_to [:admin, :cinemas], alert: "operación no habilitada para #{@theater.cinema.name}"
    end
  end
  def create_parse
    @theater = Theater.find(params[:theater_id])
    
    if @theater.cinema.id == 2
      count = params[:count].to_i
      count.times do |n|
        function = @theater.functions.new
        hash = params["function_#{n}"]
        function.show_id = hash[:show_id]
        function.function_type_ids = hash[:function_types]
        function.date = hash[:date]
        create_showtimes function, hash[:horarios]
        function.save
      end
    elsif @theater.cinema.id == 1
      count = 0
      while hash = params["movie_#{count}"]
        count2 = 0
        while hash2 = hash["function_#{count2}"]
          function = @theater.functions.new
          function.show_id = hash[:show_id]
          function.function_type_ids = hash[:function_types]
          function.date = hash2[:date]
          create_showtimes function, hash2[:horarios]
          function.save
          count2 = count2 + 1
        end
        count = count + 1
      end
    elsif @theater.cinema.id == 3
      
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
  
  def create_showtimes(function, horarios)
    horarios.gsub(/\s{3,}|( - )|(, )/, "a").split("a").each do |h|
      unless h == ""
        horaminuto = h.split(":")
        function.showtimes << Showtime.find_or_create_by_time(time: Time.new.utc.change(year:2000, month: 1, day: 1, hour: horaminuto[0], min: horaminuto[1], sec: 00))
      end
    end
  end
  def create_extra_showtimes_from_params
    date = @function.date
    7.times do |n|
      horarios = params["horarios_extra_#{n}"]
      unless horarios.blank?
        function = @theater.functions.new
        function.date = (date = date.next)
        function.function_types = @function.function_types
        function.show_id = @function.show_id
        horarios.gsub(/\s{3,}|( - )|(, )/, "a").split("a").each do |h|
          unless h == ""
            horaminuto = h.split(":")
            function.showtimes << Showtime.find_or_create_by_time(time: Time.new.utc.change(year:2000, month: 1, day: 1, hour: horaminuto[0], min: horaminuto[1], sec: 00))
          end
        end
        function.save
      end
    end
  end
  
  # GET DATOS DE LA WEB Y SETEA FUNCTIONSARRAY PARA ARMAR EL VIEW THEATERS/XX/NEW_PARSE.HTML.ERB
  def parse_cine cod
    case cod
    when 1
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
            function_types << FunctionType.find_id_by_name("Premier")
            titulo.prepend("(Premier)-")
          end
          img = item.css('img[alt="Película 3D"]')
          unless img.blank?
            function_types << FunctionType.find_id_by_name("3D")
            titulo.prepend("(3D)-")
          end
          img = item.css('img[alt="Sala XD"]')
          unless img.blank?
            function_types << FunctionType.find_id_by_name("Sala XD")
            titulo.prepend("(Sala XD)-")
          end
          function_types << FunctionType.find_id_by_name("Subtitulada") if titulo.include? "(Subtitulada)"
          function_types << FunctionType.find_id_by_name("Doblada") if titulo.include? "(Doblada)"
          function_types << FunctionType.find_id_by_name("2D") if titulo.include? "2D"

          movieFunctions = Hash[:name, titulo]
          movieFunctions[:function_types] = function_types
          
          
          movieFunctions[:functions] = []

          item.css('tr').each do |tr|
            tds = tr.css('td')
            dia = tds[0].css('strong').text.split("-") # => ["14","jun:"]
            diaweb = dia[0].to_i
            diaparams = @date.to_date.day
            mesweb = dia[1][0..2]
            mesparams = I18n.localize(date, format: :short).split(" ").last 

            if (diaparams <= diaweb && mesweb == mesparams) || (diaparams > diaweb && mesweb != mesparams)
              horarios = tds[1].text.gsub!(/\s+/, ', ')
              
              function = Hash[:day, dia.join("-")]
              function[:horarios] = horarios
              mes = 0
              if mesweb == mesparams
                mes = date.month
              else
                mes = date.next_month.month
              end
              
              function[:date] = Date.new(date.year, mes, diaweb)
              movieFunctions[:functions] << function
            end
          end
          @functionsArray << movieFunctions
        end
      else
        redirect_to [:admin, :cinemas], alert: "falta web label o date"
      end
    
    when 2
      if !@theater.web_label.blank? && @date
        date = @date.split("-").reverse.join("-")
        url = "http://www.cinehoyts.cl/?mod=#{@theater.web_label}&fecha=#{date}"
        s = open(url).read
        s.gsub!('&nbsp;', ' ') 
        page = Nokogiri::HTML(s)
    
        @functionsArray = []

        page.css('table[width="440"] tr').each_with_index do |tr, index|
          if index % 2 == 0
            text_name = tr.css('td[width="241"] span')
            if text_name
              if text_name.text.gsub!(/\s+/, ' ')
                @functionsArray << Hash[:name, text_name.text.gsub!(/\s+/, ' ')]
              else
                @functionsArray << Hash[:name, text_name.text]
              end
              function_types = []
              function_types << FunctionType.find_id_by_name("Español") if text_name.text.include? '(ESP)'
              function_types << FunctionType.find_id_by_name("Subtitulada") if text_name.text.include? '(SUBT)'
              function_types << FunctionType.find_id_by_name("3D") if text_name.text.include? '3D'
              function_types << FunctionType.find_id_by_name("Premium") if text_name.text.include? 'PREMIUM'
              @functionsArray[index/2][:function_types] = function_types
            end
          else
            if tr.css('td[width="241"] font[color="white"]')
              @functionsArray[index/2][:showtimes] = ""
              horarios = tr.css('td[width="241"] font[color="white"]').text.gsub!(/\s+/, ' ')
          
              horarios.gsub(/\s{3,}|( - )|(, )/, "a").split("a").each do |h|
                @functionsArray[index/2][:showtimes] << "#{h}, "
              end
            end
          end
        end
      else
        redirect_to [:admin, :cinemas], alert: "falta web label o date"
      end
    
    when 3
      if @date && url = params[:new_parse][:url]
        s = open(url).read
        s.gsub!('&nbsp;', ' ') 
        page = Nokogiri::HTML(s)
        
        @functionsArray = []
        
        name = ""
        lista = page.css("div.contenedor-lista-peliculas2 div.texto-lista").each_with_index do |div, index|
          strong = div.css("strong").text
          if strong.blank?
            if spans = div.css('span.flotar-izquierda')
              
              dia = spans[0].text.split(" ").last.to_i
              horarios = spans[1].text
              @functionsArray << {theater: name, date: @date.to_date.change(day: dia).to_s, horarios: horarios}
            end
          else
            name = strong
          end
        end
      end
    else
      redirect_to [:admin, :cinemas], alert: "operacion inválida para #{@theater.cinema.name}"
    end
  end
  
end
