#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'clipboard'


url = "http://www.rottentomatoes.com/m/interstellar/"
s = open(url).read
s.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').gsub!('&nbsp;', ' ') 
page = Nokogiri::HTML(s)

span = page.css("#all-critics-numbers span[itemprop=ratingValue]").first

if span != nil
  score = span.text.to_i
  puts score
end