require 'net/http'
require 'nokogiri'

include ActiveSupport::Inflector # transliterate
include ActionView::Helpers::TranslationHelper # l

namespace :parse do
  desc "Parse CineStar"
  task :cinestar => :environment do

    current_date = Date.current
    parse_days_count = 7
    parse_days = []
    parse_days_count.times do |n|
      parse_days << current_date + n
    end

    uri = URI('http://www.cinestar.cl/cartelera/')
    user_agent = {'User-Agent' => 'Firefox 28/Android: Mozilla/5.0 (Android; Mobile; rv:28.0) Gecko/24.0 Firefox/28.0'}

    hash = { "movieFunctions" => [] }

    Net::HTTP.new(uri.host).start do |http|

      request = Net::HTTP::Get.new(uri, user_agent)
      response = http.request(request)
      body = response.body.force_encoding('UTF-8')

      page = Nokogiri::HTML(body)

      page.css('#lista-peliculas div#box1 div#foto_interior1 a').each do |movie_a|

        link = movie_a['href']
        break if link.blank?
        uri2 = "http://www.cinestar.cl/#{link}"
        request2 = Net::HTTP::Get.new(uri2, user_agent)
        response2 = http.request(request2)
        body2 = response2.body.force_encoding('UTF-8')
        page2 = Nokogiri::HTML(body2)

        titulo = transliterate(page2.css('div#texto_sucursal h2').first.text.superclean).titleize
        movieFunction = {"name" => titulo, "theaters" => {}}

        page2.css('section#horario div.aparecerCine div.cine').each do |item|
          theater_slug = item["id"]
          item.css('div.peliVariedad').each do |item2|
            function_types = item2.css('h5').text.scan(/\((.*?)\)/).map { |ft| (ft[0] if ft[0].present?) }

            functions = []
            item2.css('span.horarioTitulo').each do |span_horario|
              date_array = span_horario.css('span.diaHora').text.superclean.downcase.split # ["20", "Oct", "2015", ":"]
              dia = date_array.first.to_i # 20
              mes = date_array[1] # oct
              indx = parse_days.map(&:day).index(dia)

              if indx && mes == l(parse_days[indx], format: '%b').to_s.downcase
                function = {"showtimes" => "", "dia" => dia}
                span_horario.css('a.horarioHora').each_with_index do |a_showtime, index|
                  if index == 0
                    function["showtimes"] << "#{a_showtime.text.superclean}" # 20:10
                  else
                    function["showtimes"] << ", #{a_showtime.text.superclean}" # 20:10, 22:50
                  end
                end
                functions << function if function["showtimes"].length > 0
              end
            end
            if functions.length > 0
              movieFunction["theaters"][theater_slug] = [] if movieFunction["theaters"][theater_slug].blank?
              movieFunction["theaters"][theater_slug] << {"function_types" => function_types, "functions" => functions}
            end
          end
        end
        hash["movieFunctions"] << movieFunction if movieFunction["theaters"].keys.length > 0
      end
    end

    Cinema.find_by(name: "CineStar").theaters.each do |theater|
      theater.task_parsed_hash hash
    end

  end
end
