require 'net/http'
require 'nokogiri'

namespace :parse do
  desc "Parse Antay"
  task :antay => :environment do

    current_date = Date.current
    parse_days_count = 7
    parse_days = []
    parse_days_count.times do |n|
      parse_days << current_date + n
    end

    user_agent = {'User-Agent' => 'Firefox 28/Android: Mozilla/5.0 (Android; Mobile; rv:28.0) Gecko/24.0 Firefox/28.0'}

    
    functions = []
    theater = Theater.friendly.find(theater_hash[:slug])
    parse_detector_types = theater.cinema.parse_detector_types.order('LENGTH(name) DESC')
    

    uri = URI("http://190.107.177.114/~antaycas/cine/Programacion.php")
    Net::HTTP.new(uri.host).start do |http|

      request = Net::HTTP::Get.new(uri, user_agent)
      response = http.request(request)
      body = response.body.force_encoding('UTF-8')

      page = Nokogiri::HTML(body)

      page.css('div#peliculas_en_cartelera').each do |div, index|

        uri2 = div.css('a.mix-link').first.href

        request2 = Net::HTTP::Get.new(uri2, user_agent)
        response2 = http.request(request2)
        body2 = response2.body.force_encoding('UTF-8')

        titulo = page2.css('h3#nombre_pelicula').text.superclean
        puts titulo

        last_ul = page.css('div#lista_funciones')
        while last_ul = last_ul.css('ul#lista_funciones').first do
          last_ul.children
        end
      end
    
    end # end Net::
    
    theater.override_functions(functions, parse_days.first, parse_days_count) if functions.length > 0
    
    
  end
end
