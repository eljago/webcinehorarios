include ActiveSupport::Inflector
include ActionView::Helpers::TranslationHelper

module TheaterParserHelper
  require 'http'
  require 'nokogiri'
  require 'open-uri'
  
  def save_update_parsed_show show_id, parsed_show_id, parsed_show_show_id
    if show_id && (parsed_show_show_id.blank? || parsed_show_show_id != show_id)
      parsed_show = ParsedShow.find(parsed_show_id)
      parsed_show.show_id = show_id
      parsed_show.save
    end
  end
  
  def task_parse_theater theater
    # cinema = Cinema.includes(:theaters).where({name: 'Cinemark', theaters: {active: true}}).first
    cinema = theater.cinema
    function_types = cinema.function_types.order(:name)
    shows = Show.order(:name).select('shows.id, shows.name')
    parse_detector_types = cinema.parse_detector_types.order('LENGTH(name) DESC')
    date = Date.current
    parse_days_count = 14
    
    parse_days = []
    parse_days_count.times do |n|
      parse_days << date + n
    end
    
    hash = nil
    if cinema.name == "CineStar"
      hash = parse_cinestar(theater.web_url, parse_days)
    elsif cinema.name == "Cinemark"
      hash = parse_cinemark(theater.web_url, parse_days, date)
    elsif cinema.name == "Cine Hoyts" || cinema.name == "Cinemundo"
      hash = parse_cinehoyts(theater.web_url, parse_days, theater.name)
    elsif cinema.name == "Cineplanet"
      hash = parse_cineplanet(theater.web_url, parse_days, theater.name)
    end
    
    functions_to_save = []
    hash[:movieFunctions].each do |hash_movie_function|
      titulo = hash_movie_function[:name]
      detected_function_types = []
      parsed_show_name = transliterate(titulo.gsub(/\s+/, "")).underscore # Name of the show read from the webpage then formatted
      
      movieFunctions = { name: titulo }
      parse_detector_types.each do |pdt|
        next if detected_function_types.include?(pdt.function_type_id)
        if titulo.include?(pdt.name)
          detected_function_types << pdt.function_type_id
          titulo.prepend("(#{pdt.name})-")

          # Remove the Movie Type from the Parsed Show Name
          # Parsed Show Name is gonna be used to detect the movie in the database.
         parsed_show_name.gsub!(transliterate(pdt.name.gsub(/\s+/, "")).underscore, "")
        end
      end
      parsed_show_name.gsub!(/[^a-z0-9]/i, '')
      parsed_show = ParsedShow.select('id, show_id').find_or_create_by(name: parsed_show_name)
      
      hash_movie_function[:functions].each do |hash_function|
        if hash_function[:showtimes].size >= 5
          function = theater.functions.new
          function.show_id = parsed_show.show_id
          function.function_type_ids = detected_function_types
          function.date = date.advance_to_day(hash_function[:dia])
          function.parsed_show = parsed_show
          Function.create_showtimes function, hash_function[:showtimes]
          functions_to_save << function
        end
      end
    end
    theater.override_functions(functions_to_save, Date.current, parse_days_count)
  end
  
  def parse_cinemall_quilpue
    theater = Theater.find('cinemall-quilpue')
    url = theater.web_url
    s = open(URI.escape(theater.web_url)).read
    s.gsub!('&nbsp;', ' ')
    page = Nokogiri::HTML(s)
    
    date = Date.current
    
    hash = { movieFunctions: [] }
    
    page.css('div.mainbar div.article').each_with_index do |item, index|
      titulo = item.css("#infopelicula").first.children[3].text.superclean
  
      funciones_code = item.css("#funciones")
      horarios = funciones_code.text.string_between_markers("Horarios:", "Valor").superclean
      u1 = funciones_code.css('u').first.text
      u2 = funciones_code.css('u')[1].text
      function_types = funciones_code.text.string_between_markers(u1, u2).superclean
      function_types.gsub!('NORMAL', '')
    
      titulo = titulo + " " + function_types
      
      function = { showtimes: horarios, day: date.to_s, dia: date.day }
      movieFunction = { name: titulo, functions: [function] }
      hash[:movieFunctions] << movieFunction
    end
    return hash
  end
  
  def parse_cinestar url, parse_days
    s = open(URI.escape(url)).read
    s.gsub!('&nbsp;', ' ')
    page = Nokogiri::HTML(s)
    
    hash = { movieFunctions: [] }

    page.css('article.box_interior').each_with_index do |item, index|
      titulo = item.css('header.titulo_interior').first.text.superclean
      
      movieFunction = { name: titulo, functions: []}
      
      item.css('p#idioma i').each do |item|
        item_reformatted = item.text.superclean
        if item_reformatted == 'ESPAÑOL'
          movieFunction[:name] = "#{movieFunction[:name]} (DOB)"
        elsif item_reformatted == 'INGLES'
          movieFunction[:name] = "#{movieFunction[:name]} (SUB)"
        end
      end
  
      item.css('div.boxHorario span.horarioTitulo').each_with_index do |itemFunction, index|
        function = { showtimes: [] }
        function[:day] = itemFunction.css('.diaHora').text.superclean
        dia = function[:day].split('-').last.to_i
        if parse_days.map(&:day).include?(dia)
          showtimes = []
          itemFunction.css('.horarioHora').each do |itemShowtime|
            showtimes << itemShowtime.text.superclean
          end
          function[:showtimes] = showtimes.join(', ')
          function[:dia] = dia
          movieFunction[:functions] << function
        end
      end
      hash[:movieFunctions] << movieFunction
    end
    return hash
  end
  
  def parse_cinemark url, parse_days, date
    s = open(URI.escape(url)).read
    s.gsub!('&nbsp;', ' ')
    page = Nokogiri::HTML(s)
    
    hash = { movieFunctions: [] }

    page.css('div.movie-list-inner').each do |item|
      titulo = item.css('h3 span').text.superclean
      
      movieFunction = { name: titulo, functions: []}
      
      item.css('div.version-types-wrap span').each do |item|
        item_reformatted = item.text.superclean
        if item_reformatted != 'Tradicional'
          movieFunction[:name] = "#{movieFunction[:name]} #{item_reformatted}"
        end
      end
      
      item.css('li.showtime-item').each do |item|
        function = { showtimes: [] }
        function[:day] = item.css('span.showtime-day').text.superclean
        dia = function[:day].split('-')[0].to_i
        mes = function[:day].split('-')[1].superclean.gsub(':','')
        
        if date != Date.current
          dateToValidate = date.advance_to_day(dia)
        else
          dateToValidate = date
        end
        
        mesValid = l(dateToValidate, format: '%b').to_s.downcase
        mesValid_next_month = l(dateToValidate.next_month, format: '%b').to_s.downcase
        
        # If the day read from the webpage is in the parse_days array, and the month read from the webpage is either this or next month
        # parse_days are always 7 contiguos days, so they can't be from 2 months ahead
        if parse_days.map(&:day).include?(dia) && (mes == mesValid || mes == mesValid_next_month)
          horarios = ""
          item.css('span.showtime-hour').each do |item|
            horarios << "#{item.text}, "
          end
          function[:dia] = dia
          function[:showtimes] = horarios
          movieFunction[:functions] << function
        end
      end
      hash[:movieFunctions] << movieFunction if movieFunction[:functions].count > 0
    end
    return hash
  end
  
  def parse_cinehoyts url, parse_days, theater_name
    
    dir_path = Rails.root.join(*%w( tmp cache functions ))
    FileUtils.mkdir(dir_path) unless File.exists?(dir_path)
    file_path = File.join(dir_path, "cinehoyts.txt")
    max_old_time = 60*30

    read_from_disk = nil
    if File.exists? file_path # FILE EXISTS
      time_creation = File.ctime(file_path)
      seconds_created_ago = Time.current - time_creation
      if seconds_created_ago > max_old_time
        read_from_disk = false
      else
        read_from_disk = true
      end
    else # FILE DOESN'T EXISTS
      read_from_disk = false
    end
    
    s = nil
    if read_from_disk && File.exists?(file_path)# READ FROM DISK
      s = File.read(file_path)
    else # READ FROM INTERNET
      url = "http://www.cinehoyts.cl/Cartelera"
      if Rails.env == "Production"
        proxy_ip = Settings.proxy.split(':')[0]
        proxy_port = Settings.proxy.split(':')[1]
        s = HTTP.via(proxy_ip, proxy_port.to_i).get(url).to_s
      else
        s = open(URI.escape(url)).read
      end
      s.gsub!('&nbsp;', ' ')
    
      File.open(file_path, 'w') do |f|
        f.puts s
      end
    end
    
    page = Nokogiri::HTML(s)
    hash = { movieFunctions: [] }

    page.css('p[class="fuente_azul fuente_listado"]').each_with_index do |a, index|
      
      file_path2 = File.join(dir_path, "cinehoyts_#{index}.txt")
      if read_from_disk && File.exists?(file_path2)
        s2 = File.read(file_path2)
      else
        url2 = "http://www.cinehoyts.cl#{a.parent['href']}"
        if Rails.env == "Production"
          proxy_ip = Settings.proxy.split(':')[0]
          proxy_port = Settings.proxy.split(':')[1]
          s2 = HTTP.via(proxy_ip, proxy_port.to_i).get(url2).to_s
        else
          s2 = open(URI.escape(url2)).read
        end
        s2.gsub!('&nbsp;', ' ') 
      
        File.open(file_path2, 'w') do |f|
          f.puts s2
        end
      end
      
      page2 = Nokogiri::HTML(s2)
      name = a.text
      theater_found = false
  
      page2.css('div#accordion div.panel-default').each do |cinepanel|
    
        nombre_cine = cinepanel.css('div.panel-heading h4 a').first.text.gsub('CineHoyts', '').superclean
        if transliterate(nombre_cine).underscore == transliterate(theater_name).underscore
      
          theater_found = true
      
          cinepanel.css('div.panel-body div.carousel-inner div[class="row diez_m_t"]').each do |functions_row|
            day = functions_row.css('.col-lg-2').first.text.superclean
            dia = day.split[1].to_i
            
            if parse_days.map(&:day).include?(dia)
              functions_row.css('.comprar_funcion').each do |showtime|
                clean_showtime_splitted = showtime.text.superclean.split
                time = clean_showtime_splitted.first
                function_types = clean_showtime_splitted[1..clean_showtime_splitted.length-1].join(' ')
          
                movie_name = "#{name} #{function_types}"
                movie_functions_hash = hash[:movieFunctions].get_hash_with_key_value(:name, movie_name)
                if movie_functions_hash
                  function_hash = movie_functions_hash[:functions].get_hash_with_key_value(:dia, dia)
                  if function_hash
                    function_hash[:showtimes] << "#{time}, "
                  else
                    movie_functions_hash[:functions] << { day: day, dia: dia, showtimes: "#{time}, " }
                  end
                else
                  hash[:movieFunctions] << { name: movie_name, functions: [ { day: day, dia: dia, showtimes: "#{time}, " } ] }
                end
              end
            end
          end
          break
        end
      end
    end
    return hash
  end
  
  def parse_cineplanet url, parse_days, theater_name
    
    dir_path = Rails.root.join(*%w( tmp cache functions ))
    FileUtils.mkdir(dir_path) unless File.exists?(dir_path)
    file_path = File.join(dir_path, "cineplanet.txt")
    max_old_time = 60*30

    read_from_disk = nil
    if File.exists? file_path # FILE EXISTS
      time_creation = File.ctime(file_path)
      seconds_created_ago = Time.current - time_creation
      if seconds_created_ago > max_old_time
        read_from_disk = false
      else
        read_from_disk = true
      end
    else # FILE DOESN'T EXISTS
      read_from_disk = false
    end
    
    s = nil
    if read_from_disk && File.exists?(file_path)# READ FROM DISK
      s = File.read(file_path)
    else # READ FROM INTERNET
      url = "http://www.cineplanet.cl/"
      if Rails.env == "Production"
        proxy_ip = Settings.proxy.split(':')[0]
        proxy_port = Settings.proxy.split(':')[1]
        s = HTTP.via(proxy_ip, proxy_port.to_i).get(url).to_s
      else
        s = open(URI.escape(url)).read
      end
      s.gsub!('&nbsp;', ' ')
    
      File.open(file_path, 'w') do |f|
        f.puts s
      end
    end
    
    page = Nokogiri::HTML(s)
    hash = { movieFunctions: [] }

    page.css('#lista-pelicula div.img a').each_with_index do |item, index|
      
      file_path2 = File.join(dir_path, "cineplanet_#{index}.txt")
      if read_from_disk && File.exists?(file_path2)
        s2 = File.read(file_path2)
      else
        url2 = item[:href]
        if Rails.env == "Production"
          proxy_ip = Settings.proxy.split(':')[0]
          proxy_port = Settings.proxy.split(':')[1]
          s2 = HTTP.via(proxy_ip, proxy_port.to_i).get(url2).to_s
        else
          s2 = open(URI.escape(url2)).read
        end
        s2.gsub!('&nbsp;', ' ') 
      
        File.open(file_path2, 'w') do |f|
          f.puts s2
        end
      end
      
      page2 = Nokogiri::HTML(s2) 
  
      titulo = page2.css('div[class="superior titulo-tamano-superior-modificado"]')
      next if titulo == nil
      titulo = titulo.text.superclean
      
      movieFunction = { name: titulo, functions: [] }
      
      theater_found = false
      page2.css("div.contenedor-lista-peliculas2 div.texto-lista").each do |div|
        strong = div.css("strong").text.superclean
        # si strong.empty?, entonces se está en los horarios
        if strong.empty? && theater_found
          if spans = div.css('span.flotar-izquierda')
        
            date_array = spans[0].text.split
            dia = date_array[1].to_i
            if parse_days.map(&:day).include?(dia)
              horarios = spans[1].text.superclean.gsub(' ', ', ')
              function = { day: date_array.to_s, showtimes: horarios, dia: dia }
              movieFunction[:functions] << function
            end
          end
        else
          break if theater_found
          if theater_name == "Costanera Center" && (strong == theater_name || strong == "Costanera Prime")
            theater_found = true
          elsif transliterate(strong).underscore == transliterate(theater_name).underscore
            theater_found = true
          end
        end
      end
      hash[:movieFunctions] << movieFunction if movieFunction[:functions].count > 0
    end
    return hash
  end
  
end