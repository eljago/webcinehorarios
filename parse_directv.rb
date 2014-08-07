#!/usr/bin/env ruby

require 'rubygems'
require 'watir'
require 'watir-webdriver'
require 'active_support/core_ext/time'
require 'active_support/core_ext/date'
require 'nokogiri'
require 'open-uri'
require 'clipboard'

class Date
   def advance_to_day new_day
     if new_day > day
       change(day: new_day)
     elsif new_day < day
       change(day: new_day, month: next_month.month, year: next_month.year)
     else
       self
     end
   end
end
class String
  def jago_clean
    gsub(/\r\n/,"").gsub('&nbsp;', ' ').gsub(/\s+/, ' ').strip
  end
end

browser = Watir::Browser.new :chrome
browser.goto "http://www.directv.cl/guia/guia.aspx"

begin
  loading_div = browser.div(id: 'GridLoading')
  # loading_div.wait_until_present
  loading_div.wait_while_present
  
  if ARGV[0].blank?
    day_tomorrow = Date.current+1
  else
    day_tomorrow = Date.current+ARGV[0]
  end
  date = "#{day_tomorrow.day},#{day_tomorrow.month},#{day_tomorrow.year}"
  
  calendar_span = browser.span(id: 'calender_img')
  calendar_span.click
  tomorrow_li = browser.li(id: 'ctl00_PTL_ctl01_liDay')
  tomorrow_li.wait_until_present
  tomorrow_li.hover
  tomorrow_span = browser.span(id: 'ctl00_PTL_ctl01_Label1')
  tomorrow_span.wait_until_present
  tomorrow_span.click
  
  loading_div.wait_while_present

  channels_array = []
  browser.ul(id: 'ChannelsUl').lis.each do |li|
    channels_array << li.id
  end
  puts channels_array
  
  # initialize hash variable
  hash = Hash.new
  
  browser.div(id: 'ProgramGrid').uls[11..12].each_with_index do |ul, index|
    ul.lis.each do |li|
      li.span.hover
      li.span.click
          
      event_id = li.attribute_value("eventid").to_i
      
      # wait for detail div to be present
      detail_div = browser.div(id: event_id.to_s)
      detail_div.wait_until_present
      
      # get Clasificacion
      clasificacion = detail_div.div(class: 'Rank').p(class: 'Length').text.jago_clean.gsub('Clasificación: ', '')
      
      info_arr = detail_div.div(class: 'Rank').element(:xpath => './preceding-sibling::*[1]').text.split('|')
      time = info_arr.first.strip.split(' ').last
      duration = info_arr.last.strip.split(' ').first.to_i
      
      format = 'SD'
      format = 'HD' if li.span(id: 'PG_ctl87_Prog_ctl01_imgIcon').present?

      channel = channels_array[index].to_i
      
      puts detail_div.h2s.first.text
      
      # program webpage link
      program_link = detail_div.div(class: 'Rank').a.href
      
      # read program webpage
      s = open(program_link).read
      s.gsub!('&nbsp;', ' ')
      page = Nokogiri::HTML(s)
      
      ## SERIE
      if page.css('div[id=ProgramDesc] h1')[0].present?
        # get program name
        nombre_programa = page.css('div[id=ProgramDesc] h1')[0].text.jago_clean
        # get program original name
        nombre_programa_original = page.css('div[id=ProgramDesc] h2')[0].text.jago_clean
        # get program episode name
        nombre_episodio = page.css('div[id=ProgramDesc] div.episodeNamenLink')[0].text.jago_clean
        nombre_episodio.slice! "Ver todos los episodios"
        # get program genres
        generos = page.css('div[id=ProgramDesc] div[id=divGenre] span')[0].text.jago_clean.split(', ')
        # get program description
        descripcion = page.css('div[id=ProgramDesc] div.desc')[0].text.jago_clean
      
        # hash_id = join the program name with it's genres to create the program hash key. Hopefully its unique to the program
        genres_str = ""
        generos.each do |genre|
          genres_str << genre.gsub(/\s+/,'')
        end
        hash_id = "#{nombre_programa.gsub(/\s+/,'')}#{genres_str}#{nombre_programa_original.gsub(/\s+/,'')}"
        
        # include the program in the hash
        if hash[hash_id].blank?
          hash[hash_id] = Hash.new
          hash[hash_id]["duracion"] = duration
          hash[hash_id]["nombre_programa"] = nombre_programa
          hash[hash_id]["nombre_programa_original"] = nombre_programa_original
          hash[hash_id]["nombre_episodio"] = nombre_episodio
          hash[hash_id]["generos"] = generos
          hash[hash_id]["descripcion"] = descripcion
          hash[hash_id]["clasificacion"] = clasificacion
          hash[hash_id]["functions"] = {channel => {format => {date => [time]}}}
        else
          if hash[hash_id]["functions"][channel].blank?
            hash[hash_id]["functions"][channel] = Hash.new
          end
          if hash[hash_id]["functions"][channel][format].blank?
            hash[hash_id]["functions"][channel][format] = Hash.new
          end
          if hash[hash_id]["functions"][channel][format][date].blank?
            hash[hash_id]["functions"][channel][format][date] = []
          end
          unless hash[hash_id]["functions"][channel][format][date].include?(time)
            hash[hash_id]["functions"][channel][format][date] << time
          end
        end
      
        # # loop the program functions
        # page.css('div[id=RepeaterSchedule] ul').each do |ul|
        #   ul.css('li').each do |li|
        #     divs = li.css('div')
        #     if divs.first.present?
        #       fecha = divs.first.text.strip
        #       dia = fecha.split(',')[1]
        #       dia_n = 0
        #       if dia.present?
        #         dia_n = dia.scan(/\d/).join.to_i
        #         next if (day_tomorrow.day - dia_n).abs < 5 && (dia_n < day_tomorrow.day)
        #       else
        #         dia_n = day_tomorrow.day
        #         next if fecha == "hoy"
        #       end
        #       function_date = day_tomorrow.advance_to_day dia_n
        #       function_time = li.css('div.col2').first.text.strip
        #       function_channel = li.css('span.chNum').first.text.to_i
        #       function_format = li.css('div.col4').first.text.strip
        #
        #       func_date = "#{function_date.day},#{function_date.month},#{function_date.year}"
        #
        #       if hash[hash_id]["functions"][function_channel].blank?
        #         hash[hash_id]["functions"][function_channel] = Hash.new
        #       end
        #       if hash[hash_id]["functions"][function_channel][function_format].blank?
        #         hash[hash_id]["functions"][function_channel][function_format] = Hash.new
        #       end
        #       if hash[hash_id]["functions"][function_channel][function_format][func_date].blank?
        #         hash[hash_id]["functions"][function_channel][function_format][func_date] = []
        #       end
        #       unless hash[hash_id]["functions"][function_channel][function_format][func_date].include?(function_time)
        #         hash[hash_id]["functions"][function_channel][function_format][func_date] << function_time
        #       end
        #     end
        #   end
        # end
        
      else ## PELICULA

        # get program original name
        nombre_programa_original = page.css('div[id=ucMovieDetail1_ucDetailColumn] h1 span')[0].text.jago_clean
        # get program name
        nombre_programa = page.css('div[id=ucMovieDetail1_ucDetailColumn] h1')[0].text.jago_clean.gsub(nombre_programa_original, '')
        # get año program
        ano_programa = page.css('div[id=ucMovieDetail1_ucDetailColumn] p strong span[itemprop=copyrightYear]')[0].text.jago_clean
        # get program genres
        generos = page.css('div[id=ucMovieDetail1_ucDetailColumn] span[itemprop=genre]')[0].text.jago_clean.split(', ')
        # get program description
        descripcion = page.css('div[id=tab1] span[itemprop=description]')[0].text.jago_clean

        # hash_id = join the program name with it's genres to create the program hash key. Hopefully its unique to the program
        genres_str = ""
        generos.each do |genre|
          genres_str << genre.gsub(/\s+/,'')
        end
        hash_id = "#{nombre_programa.gsub(/\s+/,'')}#{genres_str}#{nombre_programa_original.gsub(/\s+/,'')}"
        
        # include the program in the hash
        if hash[hash_id].blank?
          hash[hash_id] = Hash.new
          hash[hash_id]["duracion"] = duration
          hash[hash_id]["nombre_programa"] = nombre_programa
          hash[hash_id]["nombre_programa_original"] = nombre_programa_original
          hash[hash_id]["nombre_episodio"] = ""
          hash[hash_id]["ano"] = ano_programa
          hash[hash_id]["generos"] = generos
          hash[hash_id]["descripcion"] = descripcion
          hash[hash_id]["clasificacion"] = clasificacion
          hash[hash_id]["functions"] = {channel => {format => {date => [time]}}}
        else
          if hash[hash_id]["functions"][channel].blank?
            hash[hash_id]["functions"][channel] = Hash.new
          end
          if hash[hash_id]["functions"][channel][format].blank?
            hash[hash_id]["functions"][channel][format] = Hash.new
          end
          if hash[hash_id]["functions"][channel][format][date].blank?
            hash[hash_id]["functions"][channel][format][date] = []
          end
          unless hash[hash_id]["functions"][channel][format][date].include?(time)
            hash[hash_id]["functions"][channel][format][date] << time
          end
        end
        
      end
      
    end
  end

  Clipboard.copy hash
  
rescue Watir::Exception::UnknownObjectException => msg
  puts msg
end
  
browser.close