
namespace :parse do
  desc "Parse Metacritic"
  task :metacritic => :environment do
    require 'nokogiri'
    require 'open-uri'
    require 'timeout'
    
    date = Date.current
    shows = Show.joins('left outer join functions on shows.id = functions.show_id')
    .where('functions.date >= ? OR shows.debut > ?',date, date)
    .select('shows.id, shows.slug, shows.name, shows.metacritic_url, shows.imdb_code, shows.rotten_tomatoes_url')
    .uniq
    
    shows.each do |show|
      puts show.name
      should_save_show = false
      unless show.metacritic_url.blank?
        begin
          timeout(10) do
            URL = show.metacritic_url
            s = open(URL).read
            s.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').gsub!('&nbsp;', ' ') 
            page = Nokogiri::HTML(s)
        
            score = page.css(".main_details span[itemprop='ratingValue']").text.to_i
            unless score == 0
              puts "\t\tmeta: #{score}"
              show.metacritic_score = score
              should_save_show = true
            end
          rescue Timeout::Error
            puts "Timeout::Error: #{$!}\n"
            next
          rescue
            puts "Connection failed: #{$!}\n"
            next
          end
        end
      end
      
      unless show.imdb_code.blank?
        begin
          timeout(10) do
            URL = "http://m.imdb.com/title/#{show.imdb_code}/"
            s = open(URL).read
            s.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').gsub!('&nbsp;', ' ') 
            page = Nokogiri::HTML(s)
            score = page.css("div#ratings-bar .vertically-middle").text[0..2].to_f*10.to_i
            unless score == 0
              puts "\t\timdb: #{score}"
              show.imdb_score = score
              should_save_show = true
            end
          rescue Timeout::Error
            puts "Timeout::Error: #{$!}\n"
            next
          rescue
            puts "Connection failed: #{$!}\n"
            next
          end
        end
      end
    
      unless show.rotten_tomatoes_url.blank?
        begin
          timeout(10) do
            URL = show.rotten_tomatoes_url
            s = open(URL).read
            s.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').gsub!('&nbsp;', ' ') 
            page = Nokogiri::HTML(s)
      
            score = page.css("#all-critics-numbers span#all-critics-meter").text.to_i
            unless score == 0
              puts "\t\troten: #{score}"
              show.rotten_tomatoes_score = score
              should_save_show = true
            end
          rescue Timeout::Error
            puts "Timeout::Error: #{$!}\n"
            next
          rescue
            puts "Connection failed: #{$!}\n"
            next
          end
        end
      end
      
      show.save! if should_save_show
    end
  end
end