require 'net/http'
require 'nokogiri'

include ActiveSupport::Inflector # transliterate

namespace :parse do
  desc "Parse Cinemark Coming Soon Debut Dates"
  task :cinemark_coming_soon => :environment do

    uri = URI("http://www.cinemark.cl/proximamente")
    user_agent = {'User-Agent' => 'Firefox 28/Android: Mozilla/5.0 (Android; Mobile; rv:28.0) Gecko/24.0 Firefox/28.0'}

    Net::HTTP.new(uri.host).start do |http|

      request = Net::HTTP::Get.new(uri, user_agent)
      response = http.request(request)
      body = response.body.force_encoding('UTF-8')

      page = Nokogiri::HTML(body)

      page.css('ul[class="list movie-list-ul"] li[class="item movie-list-li box"]').each do |item|

        movie_a = item.css('h4 a')
        titulo = movie_a.text.superclean
        parsed_show_name = transliterate(titulo.gsub(/\s+/, "")).downcase 
        parsed_show_name.gsub!(/[^a-z0-9]/i, '')

        parsed_show = ParsedShow.select('id, show_id').find_or_create_by(name: parsed_show_name)

        show = parsed_show.show
        if show.present?

          uri2 = URI(movie_a.first['href'])
          request2 = Net::HTTP::Get.new(uri2, user_agent)
          response2 = http.request(request2)
          body2 = response2.body.force_encoding('UTF-8')
          page2 = Nokogiri::HTML(body2)

          debut = page2.css('div#movie-meta-info span')[1].text.superclean
          # "3 Ago, 2016"
          split_debut = debut.split
          date_day = split_debut.first.to_i
          date_year = split_debut.last.to_i
          date_month_key = split_debut.second[0..2]
          date_month = %w[Ene Feb Mar Abr May Jun Jul Ago Sep Oct Nov Dic].find_index(date_month_key) + 1
          date = Date.new date_year, date_month, date_day
          
          show_debut = show.show_debuts.new debut: date
          show_debut.save
          
          show.update_attribute :debut, date

        end

      end
    end

  end
end
