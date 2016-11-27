require 'net/http'
include ActiveSupport::Inflector # transliterate

namespace :parse do
  desc "Parse Antay"
  task :antay => :environment do

    theater = Theater.find_by(name: 'Antay Casino')
    if theater.present?

      user_agent = {'User-Agent' => 'Firefox 28/Android: Mozilla/5.0 (Android; Mobile; rv:28.0) Gecko/24.0 Firefox/28.0'}

      uri = URI.parse("http://190.107.177.114/~antaycas/cinenexo/mobile/consultas/peliculas/PeliculasConFuncionesYHorarios.php")
      
      http = Net::HTTP.new(uri.host)

      request = Net::HTTP::Post.new(uri.request_uri)

      current_date = Date.current
      functions = []

      dates = []
      7.times do |n|
        dates << current_date+n
      end
      
      dates.each do |date|
        date_str = date.strftime('%d/%m/%Y')

        request.set_form_data({"fecha" => date_str})
        response = http.request(request)
        body = response.body.force_encoding('UTF-8')
        json = JSON.parse(body)

        datos = json["datos"]
        funciones = json["funciones"]

        if funciones.length > 0

          peliculas = {}
          datos.each do |pelicula|
            peliculas[pelicula["peliculas_codigo"]] = {
              nombre: pelicula["peliculas_nombre"],
              tipo: pelicula["peliculas_tipo"]
            }
          end

          funciones.each do |funcion|
            codPeli = funcion["codPelicula"]
            pelicula = peliculas[codPeli]

            pelicula[:funciones] = {} if pelicula[:funciones].blank?
            key = [
              funcion["subtitulada"],
              pelicula[:tipo]
            ];
            pelicula[:funciones][key] = "" if pelicula[:funciones][key].blank?
            pelicula[:funciones][key] << funcion["hora"]
          end

          puts peliculas.to_s

          peliculas.each do |key, pelicula|
            if pelicula[:funciones].present?
              pelicula[:funciones].each do |key, value|

                parsed_show_name = transliterate(pelicula[:nombre].gsub(/\s+/, "")).downcase
                parsed_show_name.gsub!(/[^a-z0-9]/i, '')
                parsed_show = ParsedShow.select('id, show_id').find_or_create_by(name: parsed_show_name)
                
                detected_function_types = []
                if key[0] == "1"
                  detected_function_types << 2
                elsif key[0] == "0"
                  detected_function_types << 1
                end
                if key[1] == '2D'
                  detected_function_types << 7
                elsif key[1] == '3D'
                  detected_function_types << 3
                end

                function = theater.functions.new
                function.show_id = parsed_show.show_id
                function.function_type_ids = detected_function_types
                function.date = date
                function.parsed_show = parsed_show
                function.showtimes = value
                functions << function

              end
            end
          end
        end

      end # End TIMES
      theater.override_functions(functions, dates.first, dates.length) if functions.length > 0
    end
    
  end
end
