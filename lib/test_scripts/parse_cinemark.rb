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

page.css('div.movie-list-inner').each do |item|
  
  date = Date.today.next
  titulo = item.css('h3 span').text
  puts titulo
  
  item.css('div.version-types-wrap span').each do |item2, index2|
    puts "   " + item2.attr('class').gsub('version-', '')
  end
  
  # item.css('li.showtime-item').each_with_index do |item2, index2|
  #   day = item.css('span.showtime-day').text
  #   puts "\t#{day}"
  #   date_ar = item.css('span.showtime-day').text.superclean
  #   dia = date_ar.split('-')[0].to_i
  #   mes = date_ar.split('-')[1].superclean.gsub(':','')
  #
  #   puts dia
  #   puts mes
  #
  #   item.css('span.showtime-hour').each do |item2, index2|
  #     puts "\t\t#{item.text}"
  #   end
  # end
end