require 'net/http'
require 'nokogiri'
# require 'clipboard'
include ActiveSupport::Inflector # transliterate
include ActionView::Helpers::TranslationHelper # l

def hash_get_movieFunction hash, titulo
  hash["movieFunctions"].each do |movieFunction|
    if movieFunction["name"] == titulo
      return movieFunction
    end
  end
  nil
end

namespace :parse do
  desc "Parse Cinemark"
  task :cinehoyts_dev => :environment do

    if Rails.env.development?
      require 'watir'
      require 'watir-webdriver'

      dir_path = Rails.root.join(*%w( tmp cache functions ))
      FileUtils.mkdir(dir_path) unless File.exists?(dir_path)
      cache_cinehoyts_file_path = File.join(dir_path, "cine_hoyts.json")
      File.delete(cache_cinehoyts_file_path) if File.exists?(cache_cinehoyts_file_path)

      current_date = Date.current
      parse_days_count = 7
      parse_days = []
      parse_days_count.times do |n|
        parse_days << current_date + n
      end

      regions = ['http://www.cinehoyts.cl/cartelera/santiago-oriente',
        'http://www.cinehoyts.cl/cartelera/norte-y-centro-de-chile',
        'http://www.cinehoyts.cl/cartelera/santiago-centro',
        'http://www.cinehoyts.cl/cartelera/santiago-poniente-y-norte',
        'http://www.cinehoyts.cl/cartelera/santiago-sur',
        'http://www.cinehoyts.cl/cartelera/sur-de-chile']

      hash = { "movieFunctions" => [] }

      regions.each do |region_url|

        browser = Watir::Browser.new :chrome
        begin
          browser.goto region_url
        rescue Net::ReadTimeout
          browser.close
        end

        complejos_a_parsear = browser.execute_script('return ComplejosAParsear;')
        complejos_a_parsear.each do |complejo|

          theater_slug = complejo["CodigoComplejo"]

          complejo["Fechas"].each do |fecha|

            date_array = fecha["Fecha"].split
            dia = date_array.first.to_i
            mes = date_array.last.downcase
            mes_valid = l(current_date.advance_to_day(dia), format: '%B').to_s.downcase

            if parse_days.map(&:day).include?(dia) && mes == mes_valid
              fecha["Peliculas"].each do |pelicula|
                titulo = pelicula['Titulo'].gsub("SANFIC:", "").titleize
                movieFunction = hash_get_movieFunction(hash, titulo)
                hash_theater = nil
                new_movie_function = false
                new_array_theater = false
                # is there a movieFunction hash for this movie?
                if movieFunction
                  array_theater = movieFunction["theaters"][theater_slug]
                  unless array_theater
                    new_array_theater = true
                    array_theater = []
                  end
                else
                  array_theater = []
                  new_movie_function = true
                end

                pelicula["Formatos"].each do |formato|
                  hash_theater = {"function_types" => formato['Nombre'].gsub(/\[|\]/, '').gsub('-', ' ').split, "functions" => []}
                  hash_function = {"showtimes" => "", "dia" => dia}
                  showtimes = []
                  formato["Horarios"].each do |horario|
                    showtimes << horario["Hora"]
                  end
                  hash_function["showtimes"] = showtimes.join(", ")
                  hash_theater["functions"] << hash_function if hash_function["showtimes"].length > 0
                  array_theater << hash_theater if hash_theater["functions"].length > 0
                end
                if new_movie_function && array_theater.length > 0
                  hash["movieFunctions"] << {"name" => titulo, "theaters" => {theater_slug => array_theater}}
                end
                movieFunction["theaters"][theater_slug] = array_theater if new_array_theater
              end
            end
          end
        end if complejos_a_parsear.length > 0

        browser.close
      end


      File.open(cache_cinehoyts_file_path, 'w') {
        |file| file.write(hash.to_json)
      }

    end
  end
end
