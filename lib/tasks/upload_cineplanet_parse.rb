#!/usr/bin/env ruby

require 'rubygems'
require 'net/http'
require 'nokogiri'
require 'clipboard'

dir_path = "#{ENV['HOME']}/Documents/RailsProjects/webcinehorarios/tmp/cache"
functions_dir = "#{dir_path}/functions"
Dir.foreach(functions_dir) do |file_name|
  next if file_name == '.' or file_name == '..'
  fn = File.join(functions_dir, file_name)
  File.delete(fn)
end

uri = URI('http://www.cineplanet.cl/')
user_agent = {'User-Agent' => 'Firefox 28/Android: Mozilla/5.0 (Android; Mobile; rv:28.0) Gecko/24.0 Firefox/28.0'}

Net::HTTP.new(uri.host).start do |http|

  request = Net::HTTP::Get.new(uri, user_agent)
  response = http.request(request)
  body = response.body.force_encoding('UTF-8')

  yourfile = 'cineplanet.txt'

  fn = File.join(functions_dir, yourfile)
  File.open(fn, 'w') { |file| file.write(body) }

  page = Nokogiri::HTML(body)
  hash = { movieFunctions: [] }

  page.css('#lista-pelicula div.img a').each_with_index do |item, index|
    url2 = URI(item[:href])

    request2 = Net::HTTP::Get.new(url2, user_agent)
    response2 = http.request(request2) # Net::HTTPResponse object
    body2 = response2.body.force_encoding('UTF-8')
    yourfile2 = "cineplanet_#{index}.txt"

    fn2 = File.join(functions_dir, yourfile2)
    File.open(fn2, 'w') { |file2| file2.write(body2) }
  end

end