require 'rest-client'
require 'nokogiri'

def fetch_page(url_str)
  response = RestClient.get(url_str, {
    "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36"
  })
  if response.code == 200
    Nokogiri::HTML(response.body)
  else
    puts 'nil response. Bad URL?'
    nil
  end
end

namespace :parse do
  desc "Parse Metacritic"
  task :metacritic => :environment do

    date = Date.current
    billboard = Show.joins(:functions).where(active: true, functions: {date: date}).order(:id).distinct
    coming_soon = Show.where('(debut > ? OR debut IS ?) AND active = ?', date, nil, true).order(:id).distinct
    shows = billboard|coming_soon

    shows.each do |show|
      puts show.name
      should_save_show = false
      if show.metacritic_url.present?
        page = fetch_page(show.metacritic_url)
        if page
          text = page.css(".main_details span[itemprop='ratingValue']").text
          if text.present? && text.to_i != 0
            puts "\t\tmeta: #{text.to_i}"
            show.update_attribute(:metacritic_score, text.to_i)
            should_save_show = true
          else
            text = page.css("div.critics_col.inset_right.fl div.distribution div.metascore_w.larger.movie").text
            if text.present? && text.to_i != 0
              puts "\t\tmeta: #{text.to_i}"
              show.update_attribute(:metacritic_score, text.to_i)
              should_save_show = true
            end
          end
        end
      end

      if show.imdb_code.present?
        page = fetch_page("http://m.imdb.com/title/#{show.imdb_code}/")
        if page
          score = page.css("div#ratings-bar .vertically-middle").text[0..2].to_f*10.to_i
          unless score == 0
            puts "\t\timdb: #{score}"
            show.update_attribute(:imdb_score, score)
            should_save_show = true
          end
        end
      end

      if show.rotten_tomatoes_url.present?
        page = fetch_page(show.rotten_tomatoes_url)
        if page
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
