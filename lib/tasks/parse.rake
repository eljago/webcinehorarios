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

    shows.each do |show|
      puts show.name
      should_save_show = false
      if show.metacritic_url.present?
        page = fetch_page(show.metacritic_url)
        if page
          text = page.css(".main_details span[itemprop='ratingValue']").text.gsub(/[^0-9]/i, '')
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
          score = page.css("div#ratings-bar .vertically-middle").text.gsub(/[^0-9.]/i, '').to_f.round(2)*10.to_i
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
            score = span.text.gsub(/[^0-9]/i, '').to_i
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
