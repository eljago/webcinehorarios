#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'clipboard'


url = "http://www.rottentomatoes.com/m/interstellar/"
s = open(url).read
s.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').gsub!('&nbsp;', ' ') 
page = Nokogiri::HTML(s)

item = page.css("#all-critics-numbers span[itemprop=ratingValue]")
score = nil
if item.respond_to? :first
  score = page.css("#all-critics-numbers span[itemprop=ratingValue]").first.text.to_i
else
  score = page.css("#all-critics-numbers span[itemprop=ratingValue]").text.to_i
end
unless score == 0
  puts score
end