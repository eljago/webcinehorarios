require 'nokogiri'

namespace :download do
  desc "Parse Cinemark"
  task :cineplanet => :environment do
    
    proxy_addr = '186.67.187.162'
    proxy_port = 8080
    uri = URI('http://www.cineplanet.cl/')
    user_agent = {'User-Agent' => 'Firefox 28/Android: Mozilla/5.0 (Android; Mobile; rv:28.0) Gecko/24.0 Firefox/28.0'}

    Net::HTTP.new(uri.host).start do |http|
      # always proxy via your.proxy.addr:8080
      request = Net::HTTP::Get.new(uri, user_agent)
      response = http.request request # Net::HTTPResponse object
      body = response.body.force_encoding('UTF-8')
      
      page = Nokogiri::HTML(body)
      
      page.css('#lista-pelicula div.img a').each_with_index do |item, index|
        url2 = URI(item[:href])
        
        request2 = Net::HTTP::Get.new(url2, user_agent)
        response2 = http.request request2 # Net::HTTPResponse object
        body2 = response2.body.force_encoding('UTF-8')
        page2 = Nokogiri::HTML(body2)
        
        titulo = page2.css('div[class="superior titulo-tamano-superior-modificado"]')
        
        puts titulo
      end
    end
    
  end
end