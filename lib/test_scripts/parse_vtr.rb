#!/usr/bin/env ruby

require 'rubygems'
require 'watir'
require 'watir-webdriver'
require 'active_support/core_ext/time'
require 'active_support/core_ext/date'
require 'nokogiri'
require 'open-uri'
require 'clipboard'

class String
  def jago_clean
    gsub(/\r\n/,"").gsub('&nbsp;', ' ').gsub(/\s+/, ' ').strip
  end
end

browser = Watir::Browser.new :chrome
browser.goto "http://televisionvtr.cl/programacion/"

begin
  date_tomorrow = Date.current+1
  id_fecha = date_tomorrow.strftime("fecha_%m%d%y")
  
  browser.a(id: id_fecha).click
  
  loading_div = browser.div(class: 'opacy')
  loading_div.wait_until_present
  loading_div.wait_while_present
  
  hash_canales = Hash.new
  
  id_last_ul = browser.ul(id: 'boxgrilla').uls.last.id
  cod_canal = id_last_ul.gsub('canal_', "").to_i
  
  # Go to bottom of channels to load them all
  while
    browser.a(id: 'downgrilla').click
    loading_div.wait_until_present
    loading_div.wait_while_present
    id_last_ul = browser.ul(id: 'boxgrilla').uls.last.id
    new_cod_canal = id_last_ul.gsub('canal_', "").to_i
    break if new_cod_canal == cod_canal
    cod_canal = new_cod_canal
  end
  
  
  # add channels to hash_canales
  browser.div(id: 'canales').ul.lis.each do |li|
    numero_canal = li.strong.text.to_i
    codigo_canal = li.id.to_i
    hash_canales[codigo_canal] = {canal: numero_canal}
  end
  
  # loop current channels
  browser.ul(id: 'boxgrilla').li.uls.each_with_index do |ul, index|

    id_canal = ul.id.gsub('canal_', "").to_i
    next if hash_canales[id_canal][:canal] != 111
    if hash_canales[id_canal]["programas"].blank?
      hash_canales[id_canal]["programas"] = Hash.new
    end
    puts hash_canales[id_canal][:canal]
    
    # loop channel programs
    ul.lis.each do |li_prog|
      browser.execute_script "document.getElementById(\"#{li_prog.a.id}\").click();"
      ficha = browser.div(id: 'ficha')
      ficha.wait_until_present
      
      # Program ID
      prog_id = li_prog.attribute_value("data-prog")
      puts "\t\t#{browser.execute_script("return document.getElementById(\"#{li_prog.a.id}\").textContent")}"
      
      if !hash_canales[id_canal]["programas"].has_key?(prog_id)
        hash_canales[id_canal]["programas"][prog_id] = Hash.new
      
        # Program Name
        hash_canales[id_canal]["programas"][prog_id]["nombre"] = browser.execute_script "return document.getElementById(\"#{li_prog.a.id}\").textContent"
      
        # Program Description
        hash_canales[id_canal]["programas"][prog_id]["descripcion_programa"] = ficha.ps.first.text
        
        hash_canales[id_canal]["programas"][prog_id]["funciones"] = []
        
        # CHECK IF PROGRAM IS SPECIAL
        link_program_page = ficha.a(class: "ficha")
        if !hash_canales[id_canal]["programas"][prog_id].has_key?("especial") && link_program_page.present? && link_program_page.href[link_program_page.href.length-1] != '#'
          
          # read page using nokogiri
          s = open(link_program_page.href).read
          s.gsub!('&nbsp;', ' ')
          page = Nokogiri::HTML(s)
        
          # hash que contiene la informacion del programa especial
          especial = Hash.new
        
          div_info = page.css('div.info')
          p_desc = div_info.css('p').first.text
          p_genero = ""
          p_director = ""
          p_protagonistas = ""
          div_info.css('strong').each do |strong|
            if strong.text == "Género:"
              p_genero = strong.next_sibling.text
            elsif strong.text == "Director:"
              p_director = strong.next_sibling.text
            elsif strong.text == "Protagonistas:"
              p_protagonistas = strong.next_sibling.text
            end
          end
          especial["descripcion"] = p_desc
          especial["genero"] = p_genero
          especial["director"] = p_director
          especial["protagonistas"] = p_protagonistas
          hash_canales[id_canal]["programas"][prog_id]["especial"] = especial
        end
      end
      
      funcion = Hash.new
      # Duration
      funcion["duracion"] = li_prog.attribute_value("data-duration").to_i
      
      # Time
      date_array = li_prog.attribute_value("data-startdate").scan(/../)
      time_str = li_prog.attribute_value("data-starttime")
      time = Time.strptime("#{time_str} #{date_array[0]}#{date_array[1]} +0000", "%H%M %m%d %z")
      funcion["time"] = time
      
      hash_canales[id_canal]["programas"][prog_id]["funciones"] << funcion
      
      browser.a(id: 'cerrarf').click
    end
    # break
  end
  # break
  
  Clipboard.copy hash_canales
  
rescue Watir::Exception::UnknownObjectException => msg
  puts msg
rescue Watir::Wait::TimeoutError => msg
  Clipboard.copy hash_canales
  puts msg
end
  
browser.close