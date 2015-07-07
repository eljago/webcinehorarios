require "#{Rails.root}/app/helpers/theater_parser_helper"
include TheaterParserHelper

namespace :parse do
  desc "Parse Cinemark"
  task :cinemas => :environment do
    
    time_start = Time.current
    
    # cinestar_theaters = Cinema.where(name: "CineStar").first.theaters
    # cinestar_theaters.each do |theater|
    #   task_parse_theater(theater)
    # end
    
    cinestar_theaters = Cinema.where(name: "Cinemark").first.theaters
    cinestar_theaters.each do |theater|
      task_parse_theater theater
    end
    
    cinestar_theaters = Cinema.where(name: "Cine Hoyts").first.theaters
    cinestar_theaters.each do |theater|
      task_parse_theater theater
    end

    cinestar_theaters = Cinema.where(name: "Cinemundo").first.theaters
    cinestar_theaters.each do |theater|
      task_parse_theater theater
    end
    
    # cinestar_theaters = Cinema.where(name: "Cineplanet").first.theaters
    # cinestar_theaters.each do |theater|
    #   task_parse_theater theater
    # end
    
    if Rails.env.production?
      time_end = Time.current
      duration = time_end - time_start
      min = (duration / 60).round
      sec = (duration % 60).round
    
      date = Date.current
      from = "noreply@cinehorarios.cl"
      subject = "PARSE CINES COMPLETE #{date.day}/#{date.month}/#{date.year}"
      content = "Operación duró #{min} minutos y #{sec} segundos."
      contact_ticket = ContactTicket.new(from: from, subject: subject, content: content)
      ContactMailer.parse_complete_mailer(contact_ticket).deliver
    end
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
    .where('functions.date >= ? OR shows.debut > ?',date, date)
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
          puts "Connection failed: #{$!}\n"
        end
      end
    
      unless show.rotten_tomatoes_url.blank?
        begin
          timeout(10) do
            url = show.rotten_tomatoes_url
            s = open(url).read
            s.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').gsub!('&nbsp;', ' ') 
            page = Nokogiri::HTML(s)
            
            span = page.css("#all-critics-numbers span[itemprop=ratingValue]").first
            if span != nil
              score = span.text.to_i
              if score != 0
                puts "\t\troten: #{score}"
                show.update_attribute(:rotten_tomatoes_score, score)
                should_save_show = true
              end
            end
          end
        rescue Timeout::Error
          puts "Timeout::Error: #{$!}\n"
        rescue
          puts "Connection failed: #{$!}\n"
        end
      end
    end
  end
end