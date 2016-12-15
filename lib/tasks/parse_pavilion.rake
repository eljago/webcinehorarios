require 'net/http'
require 'nokogiri'

include ActiveSupport::Inflector # transliterate

def get_times node
  if node.present? && node['class'].present?
    next_time = get_times(node.next_element)
    if next_time.present?
      return node.text.gsub(/[^:0-9]/i, '')[0..4] + ', ' + get_times(node.next_element)
    else
      return node.text.gsub(/[^:0-9]/i, '')[0..4]
    end
  else
    nil
  end
end

namespace :parse do
  desc "Parse Pavilion"
  task :pavilion => :environment do

    current_date = Date.current
    parse_days_count = 7
    parse_days = []
    parse_days_count.times do |n|
      parse_days << current_date + n
    end

    theaters_array = [{code: 'theater20070', slug: 'pavilion-gran-avenida'},
                      {code: 'theater20069', slug: 'pavilion-punta-arenas'}]


    theaters_array.each do |theater_hash|

      functions = []
      theater = Theater.friendly.find(theater_hash[:slug])
      parse_detector_types = theater.cinema.parse_detector_types.order('LENGTH(name) DESC')

      parse_days.each do |date|

        url = date.day == current_date.day ? "https://www.cinepapaya.com/cl/pavilions" : "https://www.cinepapaya.com/cl/pavilions/#{date.strftime('%Y-%m-%d')}"
        uri = URI(url)
        body = Net::HTTP.get(uri)
        page = Nokogiri::HTML(body)

        page.css("div##{theater_hash[:code]} div.theater-showtime-box div.col-info").each do |show_box|

          title_node = show_box.css('h2.title')
          titulo = title_node.text.superclean
          parsed_show_name = transliterate(titulo.gsub(/\s+/, "")).downcase # Name of the show read from the webpage then formatted
          parsed_show_name.gsub!(/[^a-z0-9]/i, '')
          parsed_show = ParsedShow.select('id, show_id').find_or_create_by(name: parsed_show_name)

          h2s = show_box.css('h2')
          h2s.each_with_index do |h2, index|
            next if index == 0

            function_types = h2.text.superclean.split
            detected_function_types = []
            function_types.each do |hft|
              parse_detector_types.each do |pdt|
                if !detected_function_types.include?(pdt.function_type_id) && pdt.name.downcase == hft.downcase
                  detected_function_types << pdt.function_type_id
                end
              end
            end
            showtimes = get_times(h2.next_element)
            if showtimes.present? && showtimes.length > 0
              function = theater.functions.new
              function.show_id = parsed_show.show_id
              function.function_type_ids = detected_function_types
              function.date = date
              function.parsed_show = parsed_show
              function.showtimes = showtimes
              functions << function
            end
          end
        end

      end # end parse_days.each

      theater.override_functions(functions, parse_days.first, parse_days_count) if functions.length > 0
    end


  end
end
