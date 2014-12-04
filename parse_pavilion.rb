#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'

class String
  def superclean
    gsub(/\r\n/,"").gsub('&nbsp;', ' ').gsub(/\s+/, ' ').strip
  end
end


s = open("http://www.cinepavilion.cl/cartelera.html").read
s.gsub!('&nbsp;', ' ')
page = Nokogiri::HTML(s)

hash = Hash.new
hash[:functions] = []

page.css('div.home-block div.one-third-thumbs figure').each_with_index do |item, index|
  if index % 3 == 1
    
    h5 = item.css('h5').last
    puts h5.text.superclean
    next_el = h5.next_sibling
    
    puts next_el.name
    
    # h1s = item.css('h1')
 #    h2s = item.css('h2')
 #
 #    titulo = h1s[0].text.superclean
 #    puts titulo
 #
 #    if h1s[1].text.superclean == 'SANTIAGO'
 #      horarios = h2s[1].text.superclean
 #      puts horarios
 #      function_types_string = horarios.split(':').first
 #      puts function_types_string
 #      titulo = titulo + function_types_string
 #      horarios.gsub!(function_types_string, '')
 #      horarios.gsub!(/(: )|(\.)/, '')
 #      puts horarios
 #    end
  end
end