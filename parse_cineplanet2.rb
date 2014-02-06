#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'

if ARGV[0]
  if ARGV[0] == "Florida"
    URL = "http://www.cineplanet.cl/cines/florida-center/"
    theater_name = "Florida Center"
  elsif ARGV[0] == "Costanera"
    URL = "http://www.cineplanet.cl/cines/costanera-center/"
    theater_name = "Costanera Center"
  elsif ARGV[0] == "Concepcion"
    URL = "http://www.cineplanet.cl/cines/concepcion/"
    theater_name = "Concepción"
  elsif ARGV[0] == "Dehesa"
    URL = "http://www.cineplanet.cl/cines/la-dehesa/"
    theater_name = "La Dehesa"
  elsif ARGV[0] == "Alameda"
    URL = "http://www.cineplanet.cl/cines/plaza-alameda/"
    theater_name = "Plaza Alameda"
  elsif ARGV[0] == "Temuco"
    URL = "http://www.cineplanet.cl/cines/temuco/"
    theater_name = "Temuco"
  elsif ARGV[0] == "Valdivia"
    URL = "http://www.cineplanet.cl/cines/valdivia/"
    theater_name = "Valdivia"
  end

  s = open(URL).read            # Separate these three lines to convert &nbsp;
  s.gsub!('&nbsp;', ' ') 
  page = Nokogiri::HTML(s)
  
  hash = Hash.new
  hash[:complejo] = theater_name
  hash[:functions] = []

  page.css('#lista-pelicula div.img a').each_with_index do |item, index|
  
    url2 = item[:href]
    s2 = open(url2).read
    s2.gsub!('&nbsp;', ' ') 
    page2 = Nokogiri::HTML(s2) 
    
    pelicula = page2.css('div[class="superior titulo-tamano-superior-modificado"]')
    next if pelicula == nil
    pelicula = pelicula.text.split.join(' ')
    puts pelicula
    function = {name: pelicula, days: []}
    days = function[:days]
    hash[:functions] << function
    
    theater_found = false
    page2.css("div.contenedor-lista-peliculas2 div.texto-lista").each_with_index do |div, index|
      strong = div.css("strong").text
      
      # si strong.empty?, entonces se está en los horarios
      if strong.empty? && theater_found
        if spans = div.css('span.flotar-izquierda')
          
          date_array = spans[0].text.split
          horarios = spans[1].text.gsub(/\s{3,}/, ", ")
          day = {date: date_array, times: horarios}
          days << day
        end
        ignore_theater = false
      else
        break if theater_found
        if strong == theater_name
          theater_found = true
        end
      end
    end
  end
  
  puts hash
end