require 'net/http'
require 'nokogiri'

include ActiveSupport::Inflector # transliterate
include ActionView::Helpers::TranslationHelper # l

namespace :parse do
  desc "Parse Cinemark"
  task :cinemark => :environment do

    current_date = Date.current
    parse_days_count = 7
    parse_days = []
    parse_days_count.times do |n|
      parse_days << current_date + n
    end

    uri = URI('http://www.cinemark.cl/movies')
    user_agent = {'User-Agent' => 'Firefox 28/Android: Mozilla/5.0 (Android; Mobile; rv:28.0) Gecko/24.0 Firefox/28.0'}

    hash = { "movieFunctions" => [] }

    Net::HTTP.new(uri.host).start do |http|

      request = Net::HTTP::Get.new(uri, user_agent)
      response = http.request(request)
      body = response.body.force_encoding('UTF-8')

      page = Nokogiri::HTML(body)

      page.css('#main li.movie-list-li').each do |item|
        uri2 =  URI(item.css('a').first['href'])

        request2 = Net::HTTP::Get.new(uri2, user_agent)
        response2 = http.request(request2) # Net::HTTPResponse object
        body2 = response2.body.force_encoding('UTF-8')

        page2 = Nokogiri::HTML(body2)
        title = page2.css('#page-title h2').text
        movieFunction = {"name" => title, "theaters" => {}}

        page2.css('div#main ul.movie-showtime-panel').each do |lu_theater|

          theater_slug = lu_theater.attr('class').gsub('movie-showtime-panel', '').strip

          function_types_array = nil
          lu_theater.children.each do |li_functions_days|
            if li_functions_days.attr('class') == 'showtime-detail'
              li_functions_days.css('li.showtime-item').each do |li_showtime| # 18-Oct: 20:10 22:50
                date_array = li_showtime.css('span.showtime-day').first.text.split('-') # 18-Oct
                dia = date_array.first.to_i # 18
                mes = date_array.last.downcase.gsub(':','') # oct
                mesValid = l(current_date, format: '%b').to_s.downcase # oct

                if parse_days.map(&:day).include?(dia) &&
                  (mes == mesValid || (dia < current_date.day && (current_date..current_date+(parse_days.count-1)).map(&:day).include?(dia)))

                  function = {"showtimes" => "", "dia" => dia}
                  li_showtime.css('span.showtime-hour').each_with_index do |span, index|
                    if index == 0
                      function["showtimes"] << "#{span.text}" # 20:10
                    else
                      function["showtimes"] << ", #{span.text}" # 20:10, 22:50
                    end
                  end
                  movieFunction["theaters"][theater_slug].last["functions"] << function if function["showtimes"].length > 0
                end
              end
            else
              function_types_raw = li_functions_days.css('span').first.text
              function_types_array = function_types_raw.split(';')
              function_types_array << 'DOB' if !function_types_array.include?('SUB')

              movieFunction["theaters"][theater_slug] = [] if movieFunction["theaters"][theater_slug].blank?
              movieFunction["theaters"][theater_slug] << {"function_types" => function_types_array, "functions" => []}
            end
          end
        end
        hash["movieFunctions"] << movieFunction
      end
    end

    Cinema.find_by(name: "Cinemark").theaters.each do |theater|
      theater.task_parsed_hash hash
    end

  end
end
