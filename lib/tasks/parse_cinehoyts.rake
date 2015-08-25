require "#{Rails.root}/app/helpers/theater_parser_helper"
include TheaterParserHelper

namespace :parse do
  desc "Parse Cinemark"
  task :cinehoyts => :environment do
    
    # if Rails.env.production?
    if Rails.env.development?
      require 'watir'
      require 'watir-webdriver'

      db_theaters = Cinema.where(name: "Cine Hoyts").first.theaters
      theaters = []
    
      db_theaters.each do |db_theater|
        theater = {theater_id: db_theater.id, movieFunctions: []}

        browser = Watir::Browser.new :chrome
        begin
          browser.goto db_theater.web_url
        rescue Net::ReadTimeout
          browser.close
        end
        puts db_theater.web_url
    
        complejos_a_parsear = browser.execute_script('return ComplejosAParsear;')
        complejos_a_parsear.first["Fechas"].each do |fecha|
          fecha["Peliculas"].each do |pelicula|
            fecha_string = fecha["Fecha"]
            movieFunction = { functions: [] }
            pelicula["Formatos"].each do |formato|
              movieFunction[:name] = "#{formato['Nombre']} #{pelicula['Titulo']}"
              function = { showtimes: [], day: fecha_string, dia: fecha_string.split.first.to_i }
              swtimes = []
              formato["Horarios"].each do |horario|
                swtimes << horario["Hora"]
              end
              function[:showtimes] = swtimes.join(", ")
              movieFunction[:functions] << function
            end
            theater[:movieFunctions] << movieFunction
          end
        end if complejos_a_parsear.length > 0
        theaters << theater

        browser.close
      end
      
      dir_path = Rails.root.join(*%w( tmp cache functions ))
      Dir.mkdir(dir_path) unless File.exists?(dir_path)
      file_path = Rails.root.join(*%w( tmp cache functions cine_hoyts.json ))
      File.open(file_path, "w") do |file|
        file.write theaters.to_json
      end
      
    # elsif Rails.env.development?
    elsif Rails.env.production?
      
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