#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'clipboard'


url = "http://www.rottentomatoes.com/m/interstellar_2014/"
s = open(url, "User-Agent" => "Mozilla/5.0").read
s.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').gsub!('&nbsp;', ' ') 
page = Nokogiri::HTML(s)

score = page.css("#all-critics-numbers span[itemprop=ratingValue]").text.to_i
unless score == 0
  puts "\t\troten: #{score}"
end