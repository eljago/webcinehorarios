require 'net/http'
require 'nokogiri'

include ActiveSupport::Inflector # transliterate
    
def get_times node
  if node.next_sibling['href'].present?
    return Time.strptime(node.text.superclean[-8..-1], "%I:%M %P").strftime("%H:%M") + ', ' + get_times(node.next_sibling)
  else
    return Time.strptime(node.text.superclean[-8..-1], "%I:%M %P").strftime("%H:%M")
  end
end

namespace :parse do
  desc "Parse cinestar"
  task :cinestar => :environment do

    current_date = Date.current
    parse_days_count = 7
    parse_days = []
    parse_days_count.times do |n|
      parse_days << current_date + n
    end
    
    theaters_array = [{code: 'theater20100', slug: 'curico'},
                      {code: 'theater20099', slug: 'los-andes'},
                      {code: 'theater20101', slug: 'san-fernando'}]

    user_agent = {'User-Agent' => 'Firefox 28/Android: Mozilla/5.0 (Android; Mobile; rv:28.0) Gecko/24.0 Firefox/28.0'}

    theaters_array.each do |theater_hash|
      
      functions = []
      theater = Theater.friendly.find(theater_hash[:slug])
      parse_detector_types = theater.cinema.parse_detector_types.order('LENGTH(name) DESC')
      
      parse_days.each do |date|

        uri = URI("https://www.cinepapaya.com/cl/cinestar/#{date.strftime('%Y-%m-%d')}")
        Net::HTTP.new(uri.host).start do |http|

          request = Net::HTTP::Get.new(uri, user_agent)
          response = http.request(request)
          body = response.body.force_encoding('UTF-8')

          page = Nokogiri::HTML(body)
        
          parsed_day = page.css('div.date-tabs div.items a[class="item active"] div.day').text.superclean
        
          if parsed_day.to_i == date.day
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
                
                function = theater.functions.new
                function.show_id = parsed_show.show_id
                function.function_type_ids = detected_function_types
                function.date = date
                function.parsed_show = parsed_show
                times = get_times(h2.next_sibling)
                Function.create_showtimes(function, times)
                functions << function
              end
            
            end
          end
        
        end # end Net::
      end # end parse_days.each
      
      theater.override_functions(functions, parse_days.first, parse_days_count) if functions.length > 0
    end
    
    
  end
end
