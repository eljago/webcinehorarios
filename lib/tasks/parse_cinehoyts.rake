require "#{Rails.root}/app/helpers/theater_parser_helper"
include TheaterParserHelper

namespace :parse do
  desc "Parse Cinemark"
  task :cinehoyts => :environment do
    
    if Rails.env.production?
    # if Rails.env.development?
      require 'watir'
      require 'watir-webdriver'

      
      regions = ['http://www.cinehoyts.cl/cartelera/santiago-oriente',
        'http://www.cinehoyts.cl/cartelera/norte-y-centro-de-chile',
        'http://www.cinehoyts.cl/cartelera/santiago-centro',
        'http://www.cinehoyts.cl/cartelera/santiago-poniente-y-norte',
        'http://www.cinehoyts.cl/cartelera/santiago-sur',
        'http://www.cinehoyts.cl/cartelera/sur-de-chile']

      theaters = []
        
      regions.each do |region_url|
        
        browser = Watir::Browser.new :chrome
        begin
          browser.goto region_url
        rescue Net::ReadTimeout
          browser.close
        end
    
        complejos_a_parsear = browser.execute_script('return ComplejosAParsear;')
        complejos_a_parsear.each do |complejo|
          
          codigo_complejo = complejo["CodigoComplejo"]
          db_theater = Theater.find_by(web_url: "#{region_url}/#{codigo_complejo}")
          
          theater = {theater_id: db_theater.id, movieFunctions: []}
          
          complejo["Fechas"].each do |fecha| 
            fecha["Peliculas"].each do |pelicula|
              fecha_string = fecha["Fecha"]
              pelicula["Formatos"].each do |formato|
                movieFunction = { functions: [] }
                formatos = formato['Nombre'].gsub("[TRAD]", "").gsub("ORI", "")
                name = pelicula['Titulo'].gsub("SANFIC:", "")
                movieFunction[:name] = "#{formatos} #{name}"
                function = { showtimes: [], day: fecha_string, dia: fecha_string.split.first.to_i }
                swtimes = []
                formato["Horarios"].each do |horario|
                  swtimes << horario["Hora"]
                end
                function[:showtimes] = swtimes.join(", ")
                movieFunction[:functions] << function
                theater[:movieFunctions] << movieFunction
              end
            end
          end
          theaters << theater
        end if complejos_a_parsear.length > 0

        browser.close
      end
      
      dir_path = Rails.root.join(*%w( tmp cache functions ))
      Dir.mkdir(dir_path) unless File.exists?(dir_path)
      file_path = Rails.root.join(*%w( tmp cache functions cine_hoyts.json ))
      File.open(file_path, "w") do |file|
        file.write theaters.to_json
      end
      
    elsif Rails.env.development?
    # elsif Rails.env.production?
      
      time_start = Time.current
      
      cinehoyts_theaters = Cinema.where(name: "Cine Hoyts").first.theaters
      cinehoyts_theaters.each do |theater|
        task_parse_theater theater
      end
      cinemundo_theaters = Cinema.where(name: "Cinemundo").first.theaters
      cinemundo_theaters.each do |theater|
        task_parse_theater theater
      end
      
      # time_end = Time.current
      # duration = time_end - time_start
      # min = (duration / 60).round
      # sec = (duration % 60).round
      #
      # date = Date.current
      # from = "noreply@cinehorarios.cl"
      # subject = "PARSE CINE HOYTS COMPLETE #{date.day}/#{date.month}/#{date.year}"
      # content = "Operación duró #{min} minutos y #{sec} segundos."
      # contact_ticket = ContactTicket.new(from: from, subject: subject, content: content)
      # ContactMailer.parse_complete_mailer(contact_ticket).deliver
    end
    
  end
end