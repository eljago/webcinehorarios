module TheaterParserHelper
  require 'http'
  require 'nokogiri'
  require 'open-uri'
  
  def parse_cinestar url, parse_days
    s = open(URI.escape(url)).read
    s.gsub!('&nbsp;', ' ')
    page = Nokogiri::HTML(s)
    
    hash = { movieFunctions: [] }

    page.css('article.box_interior').each_with_index do |item, index|
      titulo = item.css('header.titulo_interior').first.text.superclean
      
      movieFunction = { name: titulo, functions: []}
  
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
  
  def parse_cinemark url, parse_days
    s = open(URI.escape(url)).read
    s.gsub!('&nbsp;', ' ')
    page = Nokogiri::HTML(s)
    
    hash = { movieFunctions: [] }

    page.css('div.movie-list-inner').each do |item|
      titulo = item.css('h3 span').text.superclean
      
      movieFunction = { name: titulo, functions: []}
      
      item.css('div.version-types-wrap span').each do |item|
        movieFunction[:name] = "#{movieFunction[:name]} #{item.text.superclean}"
      end
      
      item.css('li.showtime-item').each do |item|
        function = { showtimes: [] }
        function[:day] = item.css('span.showtime-day').text.superclean
        dia = function[:day].split('-').first.to_i
        if parse_days.map(&:day).include?(dia)
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
  
  def parse_cinehoyts url, parse_days
    hash = { movieFunctions: [] }
    movieFunction = nil
    
    parse_days.each do |parse_day|
      
      date_hoyts = parse_day.strftime("%d-%m-%Y")
      s = open("#{url}&fecha=#{date_hoyts}").read
      s.gsub!('&nbsp;', ' ')
      page = Nokogiri::HTML(s)

      page.css('table[width="440"] tr').each_with_index do |tr, index|
        if index % 2 == 0
          movieFunction = nil
          titulo = tr.css('td[width="241"] span').text.superclean
          if titulo
            # search if the same movie has been read on a previous date:
            hash[:movieFunctions].each do |item|
              if item[:name] == titulo
                movieFunction = item
                break
              end
            end
            if movieFunction == nil
              movieFunction = { name: titulo, functions: [] }
              hash[:movieFunctions] << movieFunction
            end
          end
        else
          if tr.css('td[width="241"] font[color="white"]')
            horarios = tr.css('td[width="241"] font[color="white"]').text.superclean
            dia = parse_day.day
            if parse_days.map(&:day).include?(dia)
              function = { day: parse_day.to_s, showtimes: horarios, dia: dia }
              movieFunction[:functions] << function
            end
          end
        end
      end
    end
    return hash
  end
  
  def parse_cineplanet url, parse_days, theater_name
    url = "http://www.cineplanet.cl/"
  
    if Rails.env == "Production"
      proxy_ip = Settings.proxy.split(':')[0]
      proxy_port = Settings.proxy.split(':')[1]
      s = HTTP.via(proxy_ip, proxy_port.to_i).get("http://www.cineplanet.cl/").to_s
    else
      s = open(URI.escape("http://www.cineplanet.cl/")).read
    end
    s.gsub!('&nbsp;', ' ') 
    page = Nokogiri::HTML(s)
    
    hash = { movieFunctions: [] }

    page.css('#lista-pelicula div.img a').each do |item|

      url2 = item[:href]
      if Rails.env == "Production"
        proxy_ip = Settings.proxy.split(':')[0]
        proxy_port = Settings.proxy.split(':')[1]
        s2 = HTTP.via(proxy_ip, proxy_port.to_i).get(url2).to_s
      else
        s2 = open(URI.escape(url2)).read
      end
      s2.gsub!('&nbsp;', ' ') 
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
          elsif strong == theater_name
            theater_found = true
          end
        end
      end
      hash[:movieFunctions] << movieFunction if movieFunction[:functions].count > 0
    end
    return hash
  end
  
end