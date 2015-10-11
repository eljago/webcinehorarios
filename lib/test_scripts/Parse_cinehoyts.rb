#!/usr/bin/env ruby

require 'rubygems'
require 'watir'
require 'watir-webdriver'

uri = 'http://www.cinehoyts.cl/cartelera/santiago-oriente/parque-arauco'

browser = Watir::Browser.new :chrome
browser.goto uri

movieFunctions = []

complejos_a_parsear = browser.execute_script('return ComplejosAParsear;')
complejos_a_parsear.first["Fechas"].each do |fecha|
  fecha["Peliculas"].each do |pelicula|
    movieFunction = { name: pelicula["Titulo"], functions: [], date: fecha["Fecha"] }
    pelicula["Formatos"].each do |formato|
      function = { function_types: formato["Nombre"], showtimes: [] }
      formato["Horarios"].each do |horario|
        function[:showtimes] << horario["Hora"]
      end
      movieFunction[:functions] << function
    end
    movieFunctions << movieFunction
  end
end

puts movieFunctions

File.open("cine_hoyts.txt", "w") do |file|
  file.write movieFunctions
end

browser.close