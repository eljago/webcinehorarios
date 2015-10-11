#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'

class String
  def superclean
    gsub(/\r\n/,"").gsub('&nbsp;', ' ').gsub(/\s+/, ' ').strip
  end
end


s = open("http://www.cinestar.cl/complejo/3/Curic%C3%B3").read
s.gsub!('&nbsp;', ' ')
page = Nokogiri::HTML(s)

hash = Hash.new
hash[:functions] = []

page.css('article.box_interior').each_with_index do |item, index|
  titulo = item.css('header.titulo_interior').first.text.superclean
  puts titulo
  
  function = {name: titulo, days: []}
  days = function[:days]
  hash[:functions] << function
  
  item.css('div.boxHorario span.horarioTitulo').each_with_index do |itemFunction, index|
    
    dia = itemFunction.css('.diaHora').text.superclean
    puts "\t#{dia}"
    
    itemFunction.css('.horarioHora').each do |itemShowtime|
      
      showtime = itemShowtime.text.superclean
      puts "\t\t#{showtime}"
      
    end
    
  end
  hash
end