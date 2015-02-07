#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'

class String
  def superclean
    gsub(/\r\n/,"").gsub('&nbsp;', ' ').gsub(/\s+/, ' ').strip
  end
end
class String
  def string_between_markers marker1, marker2
    self[/#{Regexp.escape(marker1)}(.*?)#{Regexp.escape(marker2)}/m, 1]
  end
end

s = open("http://www.cinemallquilpue.cl/cartelera.html").read
s.gsub!('&nbsp;', ' ')
page = Nokogiri::HTML(s)

page.css('div.mainbar div.article').each_with_index do |item, index|

  titulo = item.css("#infopelicula").first.children[3].text.superclean
  
  funciones_code = item.css("#funciones")
  horarios = funciones_code.text.string_between_markers("Horarios:", "Valor").superclean
  u1 = funciones_code.css('u').first.text
  u2 = funciones_code.css('u')[1].text
  function_types = funciones_code.text.string_between_markers(u1, u2).superclean
  puts titulo
  puts horarios
  puts function_types

end