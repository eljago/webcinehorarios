
namespace :parse do
  desc "Parse Metacritic"
  task :metacritic => :environment do
    require 'nokogiri'
    require 'open-uri'
    
    date = Date.current
    shows = Show.joins('left outer join functions on shows.id = functions.show_id')
    .where('functions.date >= ? OR shows.debut > ?',date, date)
    .select('shows.name, shows.metacritic_url').uniq.all
    
    shows.each do |show|
      unless show.metacritic_url.blank?
        puts show.metacritic_url
        URL = show.metacritic_url
        s = open(URL).read
        s.gsub!('&nbsp;', ' ') 
        page = Nokogiri::HTML(s)
        
        score = page.css(".main_details span.score_value").text.to_i
        unless score == 0
          show.metacritic_score = score
          show.save
        end
      end
    end
  end
end