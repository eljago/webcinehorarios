
namespace :parse do
  desc "Parse Metacritic"
  task :metacritic => :environment do
    require 'nokogiri'
    require 'open-uri'
    
    date = Date.current
    shows = Show.joins('left outer join functions on shows.id = functions.show_id')
    .where('functions.date >= ? OR shows.debut > ?',date, date)
    .select('shows.id, shows.slug, shows.name, shows.metacritic_url, shows.imdb_code, shows.rotten_tomatoes_url')
    .uniq
    
    shows.each do |show|
      puts show.name
      should_save_show = false
      unless show.metacritic_url.blank?
        puts "\tparsing metacritic ..."
        URL = show.metacritic_url
        s = open(URL).read
        s.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').gsub!('&nbsp;', ' ') 
        page = Nokogiri::HTML(s)
        
        score = page.css(".main_details span[itemprop='ratingValue']").text.to_i
        unless score == 0
          puts "\t\tmetacritic score: #{score}"
          show.metacritic_score = score
          should_save_show = true
        end
      end
      
      unless show.imdb_code.blank?
        puts "\tparsing imdb ..."
        URL = "http://m.imdb.com/title/#{show.imdb_code}/"
        s = open(URL).read
        s.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').gsub!('&nbsp;', ' ') 
        page = Nokogiri::HTML(s)
        score = page.css("p.votes strong").text.to_f*10.to_i
        unless score == 0
          puts "\t\timdb score: #{score}"
          show.imdb_score = score
          should_save_show = true
        end
      end
    
      unless show.rotten_tomatoes_url.blank?
        puts "\tparsing rotten tomatoes ..."
        URL = show.rotten_tomatoes_url
        s = open(URL).read
        s.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '').gsub!('&nbsp;', ' ') 
        page = Nokogiri::HTML(s)
      
        score = page.css("#all-critics-numbers span#all-critics-meter").text.to_i
        unless score == 0
          puts "\t\trotten tomatoes score: #{score}"
          show.rotten_tomatoes_score = score
          should_save_show = true
        end
      end
      
      show.save! if should_save_show
    end
  end
end