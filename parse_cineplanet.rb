#!/usr/bin/env ruby

require 'rubygems'
require 'watir'
require 'watir-webdriver'
require 'active_support/core_ext/time'

if ARGV[0]
  cinema = ARGV[0]
  browser = Watir::Browser.new :chrome
  browser.goto "https://ecommerce.movieland.cl/movieland_produccion/tienda/seleccionarentrada.php"
  # browser.select_list(:name, "complejo_id").click

  complejos = browser.select_list(:name, "select1").options
  
  hash = Hash.new
  hash[:complejo] = cinema
  hash[:functions] = []

  for c in 0..(complejos.size-1)
    complejo = browser.select_list(:name, "select1").options[c].text
    puts complejo
    if complejo.include? cinema
      browser.select_list(:name, "select1").options[c].click
      sleep(0.1)
  
      browser.wait_until{browser.select_list(:name, "select2").present?}
      browser.wait_until{browser.select_list(:name, "select2").options.size > 0}
      peliculas = browser.select_list(:name, "select2").options
      for p in 0..(peliculas.size-1)
        pelicula =  browser.select_list(:name, "select2").options[p].text
        function = {name: pelicula, days: []}
        hash[:functions] << function
        
        puts "\t#{pelicula}"
        
        browser.select_list(:name, "select2").options[p].click
        sleep(0.1)
      
        browser.wait_until{browser.select_list(:name, "select3").present?}
        browser.wait_until{browser.select_list(:name, "select3").options.present?}
        fechas = browser.select_list(:name, "select3").options
        
        days = function[:days]
        
        fechas.each do |fecha|
          fecha_array = fecha.text.split(/\s*-\s*/)
          date_array = fecha_array[0].split(', ').last.split('/').reverse
          date = Date.new(date_array[0].to_i, date_array[1].to_i, date_array[2].to_i)
          
          if days.size == 0 || days.last[:date] != date_array
            days << {date: date_array, times: "" }
          end
          
          time_array = fecha_array[1].split # => ["12:30, "AM""]
          hora_min_array = time_array[0].split(':') # => ["12", "30"]
          hora = hora_min_array[0].to_i # => 12
          min = hora_min_array[1].to_i # => 30
          time = date.to_time.change(hour: hora, min: min)
          time = time+60*60*12 if time_array[1] == "PM"
          days.last[:times] << "#{time.hour}:#{time.min}, "
        end
      end
      break
    end
  end
  browser.close
  
  puts hash
end

