#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'


class String
  def superclean
    gsub(/\r\n/,"").gsub('&nbsp;', ' ').gsub(/\s+/, ' ').strip
  end
end

URL = "http://www.cinemark.cl/theatres/alto-las-condes"
s = open(URL).read            # Separate these three lines to convert &nbsp;
s.gsub!('&nbsp;', ' ') 
page = Nokogiri::HTML(s)   

page.css('div.movie-list-inner').each_with_index do |item, index|
  
  date = Date.today.next
  titulo = item.css('h3 span').text
  puts titulo
  
  item.css('div.version-types-wrap span').each do |item, index|
    puts item.text
  end
  
  item.css('li.showtime-item').each_with_index do |item, index|
    day = item.css('span.showtime-day').text
    puts "\t#{day}"
    date_ar = item.css('span.showtime-day').text.superclean
    dia = date_ar.split('-')[0].to_i
    mes = date_ar.split('-')[1].superclean.gsub(':','')
    
    puts dia
    puts mes
    
    item.css('span.showtime-hour').each do |item, index|
      puts "\t\t#{item.text}"
    end
  end
end