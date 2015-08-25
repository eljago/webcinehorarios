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
    
    # if cinema.slug == 'cinemundo' || cinema.slug == 'cine-hoyts'
    #   date = date+1 if Time.current.hour > 19
    # end
    
    parse_days = []
    parse_days_count.times do |n|
      parse_days << date + n
    end
    
    hash = nil
    if cinema.slug == "cinestar"
      hash = parse_cinestar(theater.web_url, parse_days)
    elsif cinema.slug == "cinemark"
      hash = parse_cinemark(theater.web_url, parse_days, date)
    elsif cinema.slug == "cine-hoyts" || cinema.slug == "cinemundo"
      hash = parse_cinehoyts(theater.id)
    elsif cinema.slug == "cineplanet"
      hash = parse_cineplanet(theater.web_url, parse_days, theater.name)
    end
    
    functions_to_save = []
    hash[:movieFunctions].each do |hash_movie_function|
      titulo = hash_movie_function[:name]
      detected_function_types = []
      parsed_show_name = transliterate(titulo.gsub(/\s+/, "")).downcase # Name of the show read from the webpage then formatted
      
      movieFunctions = { name: titulo }
      parse_detector_types.each do |pdt|
        next if detected_function_types.include?(pdt.function_type_id)
        if titulo.include?(pdt.name)
          detected_function_types << pdt.function_type_id
          titulo.prepend("(#{pdt.name})-")

          # Remove the Movie Type from the Parsed Show Name
          # Parsed Show Name is gonna be used to detect the movie in the database.
         parsed_show_name.gsub!(transliterate(pdt.name.gsub(/\s+/, "")).downcase, "")
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
          functions_to_save << function if function.showtimes.length > 0
        end
      end
    end
    theater.override_functions(functions_to_save, date, parse_days_count) if functions_to_save.length > 0
  end
  
  def parse_cinemall_quilpue
    theater = Theater.find('cinemall-quilpue')
    url = theater.web_url

    proxy_ip = Settings.proxy.split(':')[0]
    proxy_port = Settings.proxy.split(':')[1]
    s = HTTP.via(proxy_ip, proxy_port.to_i).get(url).to_s
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
          movieFunction[:functions] << function if function[:showtimes].length > 0
        end
      end
      hash[:movieFunctions] << movieFunction if movieFunction[:functions].length > 0
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
        item_class = item.attr('class').gsub('version-', '')
        if item_class != 'trad'
          movieFunction[:name] = "#{movieFunction[:name]} #{item_class}"
        end
      end
      
      item.css('li.showtime-item').each do |item|
        function = { showtimes: [] }
        function[:day] = item.css('span.showtime-day').text.superclean
        dia = function[:day].split('-')[0].to_i
        mes = function[:day].split('-')[1].superclean.downcase.gsub(':','')
        
        mesValid = l(date, format: '%b').to_s.downcase
        
        if parse_days.map(&:day).include?(dia) && (mes == mesValid || (dia < date.day && (date..date+(parse_days.count-1)).map(&:day).include?(dia)))
          horarios = ""
          item.css('span.showtime-hour').each do |item|
            horarios << "#{item.text}, "
          end
          function[:dia] = dia
          function[:showtimes] = horarios
          movieFunction[:functions] << function if function[:showtimes].length > 0
        end
      end
      hash[:movieFunctions] << movieFunction if movieFunction[:functions].length > 0
    end
    return hash
  end
  
  def parse_cinehoyts theater_id
    
    file_path = Rails.root.join(*%w( tmp cache functions cine_hoyts.json ))
    if File.exists?(file_path)
      s = File.read(file_path)
      hash_array = eval s
      hash_array.each do |theater_item|
        if theater_item[:theater_id].present? && theater_item[:theater_id] == theater_id
          return theater_item
        end
      end
    end
  end
  
  def parse_cineplanet url, parse_days, theater_name
    
    dir_path = Rails.root.join(*%w( tmp cache functions ))
    FileUtils.mkdir(dir_path) unless File.exists?(dir_path)
    file_path = File.join(dir_path, "cineplanet.txt")
    
    s = nil
    if File.exists?(file_path)
      s = File.read(file_path)
    else
      return
    end
    
    page = Nokogiri::HTML(s)
    hash = { movieFunctions: [] }

    page.css('#lista-pelicula div.img a').each_with_index do |item, index|

      file_path2 = File.join(dir_path, "cineplanet_#{index}.txt")

      s2=nil
      if File.exists?(file_path2)
        s2 = File.read(file_path2)
      else
        return
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
              movieFunction[:functions] << function if function[:showtimes].length > 0
            end
          end
        else
          break if theater_found
          if theater_name == "Costanera Center" && (strong == theater_name || strong == "Costanera Prime")
            theater_found = true
          elsif transliterate(strong).downcase == transliterate(theater_name).downcase
            theater_found = true
          end
        end
      end
      hash[:movieFunctions] << movieFunction if movieFunction[:functions].length > 0
    end
    return hash
  end
  
end