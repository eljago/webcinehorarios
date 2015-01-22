#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'active_support/core_ext/object/blank'

class String
  def superclean
    gsub(/\r\n/,"").gsub('&nbsp;', ' ').gsub(/\s+/, ' ').strip
  end
end

class Array
  def contains_hash_with_key_value? key, value
    each do |hash|
      return true if hash.has_key?(key) && hash[key] == value
    end
    false
  end
  
  def get_hash_with_key_value key, value
    each do |hash|
      return hash if hash.has_key?(key) && hash[key] == value
    end
    nil
  end
end

s = open(URI.escape("http://www.cinehoyts.cl/Cartelera")).read
s.gsub!('&nbsp;', ' ')
page = Nokogiri::HTML(s)

hash = { movieFunctions: [] }
theater_name = "La Reina"

page.css('p[class="fuente_azul fuente_listado"]').each do |a|
  link = "http://www.cinehoyts.cl#{a.parent['href']}"
  puts link
  name = a.text
  
  s2 = open(URI.escape(link)).read
  s2.gsub!('&nbsp;', ' ')
  page2 = Nokogiri::HTML(s2)
  
  theater_found = false
  
  page2.css('div#accordion div.panel-default').each do |cinepanel|
    
    nombre_cine = cinepanel.css('div.panel-heading h4 a').first.text.gsub('CineHoyts', '').superclean
    if nombre_cine == theater_name
      
      theater_found = true
      
      cinepanel.css('div.panel-body div.carousel-inner div[class="row diez_m_t"]').each do |functions_row|
        day = functions_row.css('.col-lg-2').first.text.superclean
        dia = day.split[1].to_i
        
        functions_row.css('.comprar_funcion').each do |showtime|
          clean_showtime_splitted = showtime.text.superclean.split
          time = clean_showtime_splitted.first
          function_types = clean_showtime_splitted[1..clean_showtime_splitted.length-1].join(' ')
          
          movie_name = "#{name} #{function_types}"
          movie_functions_hash = hash[:movieFunctions].get_hash_with_key_value(:name, movie_name)
          if movie_functions_hash
            function_hash = movie_functions_hash[:functions].get_hash_with_key_value(:dia, dia)
            if function_hash
              function_hash[:showtimes] << "#{time}, "
            else
              movie_functions_hash[:functions] << { day: day, dia: dia, showtimes: "#{time}, " }
            end
          else
            hash[:movieFunctions] << { name: movie_name, functions: [ { day: day, dia: dia, showtimes: "#{time}, " } ] }
          end
        end
      end
      break
    end
  end
end
puts hash