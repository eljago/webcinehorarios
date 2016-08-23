require 'net/http'
require 'nokogiri'
# require 'clipboard'
include ActiveSupport::Inflector # transliterate
include ActionView::Helpers::TranslationHelper # l

namespace :parse do
  desc "Parse Cineplanet Development"
  task :cineplanet_dev => :environment do

    if Rails.env.development?

      dir_path = Rails.root.join(*%w( tmp cache functions ))
      FileUtils.mkdir(dir_path) unless File.exists?(dir_path)
      cache_cineplanet_file_path = File.join(dir_path, "cineplanet.json")
      File.delete(cache_cineplanet_file_path) if File.exists?(cache_cineplanet_file_path)

      current_date = Date.current
      parse_days_count = 7
      parse_days = []
      parse_days_count.times do |n|
        parse_days << current_date + n
      end

      hash = { movieFunctions: [] }

      uri = URI('http://www.cineplanet.cl/')
      user_agent = {'User-Agent' => 'Firefox 28/Android: Mozilla/5.0 (Android; Mobile; rv:28.0) Gecko/24.0 Firefox/28.0'}

      Net::HTTP.new(uri.host).start do |http|

        request = Net::HTTP::Get.new(uri, user_agent)
        response = http.request(request)
        body = response.body.force_encoding('UTF-8')

        page = Nokogiri::HTML(body)
        page.css('#lista-pelicula div.img a').each_with_index do |item, index|

          uri2 = URI(item[:href])
          request2 = Net::HTTP::Get.new(uri2, user_agent)
          response2 = http.request(request2)
          body2 = response2.body.force_encoding('UTF-8')
          page2 = Nokogiri::HTML(body2)
          titulo = page2.css('div[class="superior titulo-tamano-superior-modificado"] h2.proximamente')
          next if titulo == nil
          titulo = titulo.text.superclean

          function_types_array = []
          parse_detector_types = Cinema.find_by(name: 'Cineplanet').parse_detector_types.order('LENGTH(name) DESC')
          parse_detector_types.each do |pdt|
            if titulo.include?(pdt.name)
              function_types_array << pdt.name
              titulo = titulo.gsub(pdt.name, '')
            end
          end
          titulo = transliterate(titulo).gsub(/[^a-z0-9]/i, '')

          movieFunction = { name: titulo, theaters: {} }

          valid_theater_slug = nil
          page2.css("div.contenedor-lista-peliculas2 div.texto-lista").each do |div|
            theater_slug = transliterate(div.css("strong").text.superclean).downcase
            # si theater_slug.empty?, entonces se está en los horarios
            if theater_slug.empty?
              if spans = div.css('span.flotar-izquierda')

                date_array = spans[0].text.split
                mes = date_array[0].superclean.downcase # jueves
                dia = date_array[1].to_i # 18
                indx = parse_days.map(&:day).index(dia)
                
                if indx && mes == l(parse_days[indx], format: '%A').to_s.downcase
                  horarios = spans[1].text.superclean.gsub(/\s+/, ', ')
                  function = { showtimes: horarios, dia: dia }
                  movieFunction[:theaters][valid_theater_slug].last[:functions] << function if function[:showtimes].length > 0
                end
              end
            else
              valid_theater_slug = theater_slug
              movieFunction[:theaters][theater_slug] = [] if movieFunction[:theaters][theater_slug].blank?
              movieFunction[:theaters][theater_slug] << { function_types: function_types_array, functions: [] }
            end
          end
          hash[:movieFunctions] << movieFunction

        end

      end

      # Write file to cache/functions/cineplanet.json
      File.open(cache_cineplanet_file_path, 'w') {
        |file| file.write(hash.to_json)
      }

      # Clipboard.copy hash.to_json


    end
  end
end
