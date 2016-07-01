def fetch(uri_str, limit = 10)
  # You should choose a better exception.
  raise ArgumentError, 'too many HTTP redirects' if limit == 0

  response = Net::HTTP.get_response(URI(uri_str))

  case response
  when Net::HTTPSuccess then
    response
  when Net::HTTPRedirection then
    location = response['location']
    warn "redirected to #{location}"
    fetch(location, limit - 1)
  else
    # response.value
    nil
  end
end

namespace :parse do
  desc "Parse Metacritic"
  task :metacritic => :environment do
    require 'nokogiri'
    require 'open-uri'
    require 'timeout'

    date = Date.current
    shows = Show.joins('left outer join functions on shows.id = functions.show_id')
    .where('(functions.date >= ? OR (shows.debut > ? OR shows.debut IS ?)) AND shows.active = ?',date, date, nil, true)
    .uniq
    
    shows.each do |show|
      puts show.name
      should_save_show = false
      unless show.metacritic_url.blank?
        begin
          timeout(10) do
            url = show.metacritic_url
            s = open(url, "User-Agent" => "Mozilla/5.0").read
            s.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').gsub!('&nbsp;', ' ')
            page = Nokogiri::HTML(s)

            score = page.css(".main_details span[itemprop='ratingValue']").text.to_i
            unless score == 0
              puts "\t\tmeta: #{score}"
              show.update_attribute(:metacritic_score, score)
              should_save_show = true
            end
          end
        rescue Timeout::Error
          puts "Timeout::Error: #{$!}\n"
        rescue
          if $!.to_s === '404 Not Found'
            show.update_attribute(:metacritic_url, '')
            show.update_attribute(:metacritic_score, 0)
            puts "reseted metacritic code and score\n"
          end
          puts "Connection failed: #{$!}\n"
        end
      end

      unless show.imdb_code.blank?
        begin
          timeout(10) do
            url = "http://m.imdb.com/title/#{show.imdb_code}/"
            s = open(url, "User-Agent" => "Mozilla/5.0").read
            s.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').gsub!('&nbsp;', ' ')
            page = Nokogiri::HTML(s)
            score = page.css("div#ratings-bar .vertically-middle").text[0..2].to_f*10.to_i
            unless score == 0
              puts "\t\timdb: #{score}"
              show.update_attribute(:imdb_score, score)
              should_save_show = true
            end
          end
        rescue Timeout::Error
          puts "Timeout::Error: #{$!}\n"
        rescue
          if $!.to_s === '404 Not Found'
            show.update_attribute(:imdb_code, '')
            show.update_attribute(:imdb_score, 0)
            puts "reseted imdb code and score\n"
          end
          puts "Connection failed: #{$!}\n"
        end
      end

      unless show.rotten_tomatoes_url.blank?
        response = fetch(show.rotten_tomatoes_url)
        if response.present?
          body = response.body
          if body.present?
            page = Nokogiri::HTML(body)

            span = page.css("#all-critics-numbers span.meter-value").first
            if span.present?
              score = span.text[0..1].to_i
              if score != 0
                puts "\t\troten: #{score}"
                show.update_attribute(:rotten_tomatoes_score, score)
                should_save_show = true
              end
            end
          end
        end
      end
    end
  end
end
