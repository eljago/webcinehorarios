require 'rest-client'
require 'nokogiri'

def notify_error url_str, description = "URL INVALIDA"
  puts description
  problem = {description: description}
  NotifyProblemMailer.notify_problem(problem).deliver_later
end

def fetch_page(url_str)
  begin
    response = RestClient.get(url_str, {
      "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.95 Safari/537.36"
    })
    if response.code == 200
      return Nokogiri::HTML(response.body)
    else
      notify_error url_str, "URL INVALIDA ?"
    end
  rescue RestClient::ExceptionWithResponse => e
    notify_error url_str, "URL INVALIDA: #{url_str}"
  rescue Errno::ECONNREFUSED => e
    notify_error url_str, "ERROR DE CONEXION"
  end
  nil
end

namespace :parse do
  desc "Parse Metacritic"
  task :metacritic => :environment do

    date = Date.current
    billboard = Show.joins(:functions).where(active: true, functions: {date: date}).order(:id).distinct
    coming_soon = Show.where('(debut > ? OR debut IS ?) AND active = ?', date, nil, true).order(:id).distinct
    shows = billboard|coming_soon

    # shows = Show.where(name: 'En el ático')
    # shows = Show.where(name: 'Dunkerque')

    shows.each do |show|
      puts show.name
      if show.metacritic_url.present?
        page = fetch_page(show.metacritic_url)
        if page
          score_str = page.css(".main_details span[itemprop='ratingValue']").text.gsub(/[^0-9]/i, '')
          if score_str.length > 0
            score = score_str.to_i
            puts "\t\tmeta: #{score}"
            show.update_attribute(:metacritic_score, score)
          else
            score_str = page.css("div.critics_col.inset_right.fl div.distribution div.metascore_w.larger.movie").text.gsub(/[^0-9]/i, '')
            if score_str.length > 0
              score = score_str.to_i
              puts "\t\tmeta: #{score}"
              show.update_attribute(:metacritic_score, score)
            end
          end
        end
      end

      if show.imdb_code.present?
        page = fetch_page("http://m.imdb.com/title/#{show.imdb_code}/")
        if page
          score_text = score_str = page.css("div#ratings-bar .vertically-middle").text # 8/1086,828
          score_splitted = score_text.split('/')
          if score_splitted && score_splitted.length > 0
            score_str = score_splitted.first.gsub(/[^0-9.]/i, '')
            if score_str.present?
              score = score_str.to_f*10.to_i
              puts "\t\timdb: #{score}"
              show.update_attribute(:imdb_score, score)
            end
          end
        end
      end

      if show.rotten_tomatoes_url.present?
        page = fetch_page(show.rotten_tomatoes_url)
        if page
          span = page.css("#all-critics-numbers span.meter-value").first
          if span.present?
            score_str = span.text.gsub(/[^0-9]/i, '')
            if score_str.length > 0
              score = score_str.to_i
              puts "\t\troten: #{score}"
              show.update_attribute(:rotten_tomatoes_score, score)
            end
          end
        end
      end
    end
  end
end
