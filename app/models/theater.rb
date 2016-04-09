# == Schema Information
#
# Table name: theaters
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  image        :string(255)
#  address      :string(255)
#  information  :text
#  cinema_id    :integer
#  city_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#  web_url      :string(255)
#  active       :boolean
#  slug         :string(255)
#  latitude     :decimal(15, 10)
#  longitude    :decimal(15, 10)
#  parse_helper :string(255)
#
# Indexes
#
#  index_theaters_on_city_id_and_cinema_id  (city_id,cinema_id)
#  index_theaters_on_slug                   (slug) UNIQUE
#

class Theater < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  # attr_accessible :cinema_id, :city_id, :address, :information, :latitude, :longitude, :name, :web_url, :function_type_ids, :active

  belongs_to :city
  belongs_to :cinema
  has_many :functions, :dependent => :destroy

  validates :name, :presence => :true

  accepts_nested_attributes_for :functions

  def self.find_id_by_name name
    theater = where(name: name).first
    if theater
      theater.id
    else
      0
    end
  end

  after_commit :flush_cache

  def self.cached_api_theaters cinema_id
    Rails.cache.fetch([name, 'api_theaters', cinema_id]) do
      where(cinema_id: cinema_id, active: true).order([:cinema_id, :name]).to_a
    end
  end

  def flush_cache
    Rails.cache.delete([self.class.name, "api_theaters"])
  end

  def task_parsed_hash hash
    function_types = cinema.function_types.order(:name)
    parse_detector_types = cinema.parse_detector_types.order('LENGTH(name) DESC')
    current_date = Date.current
    parse_days_count = 7

    functions_to_save = []

    hash["movieFunctions"].each do |hash_movie_function|

      titulo = hash_movie_function["name"]
      parsed_show_name = transliterate(titulo.gsub(/\s+/, "")).downcase # Name of the show read from the webpage then formatted
      parsed_show_name.gsub!(/[^a-z0-9]/i, '')
      parsed_show = ParsedShow.select('id, show_id').find_or_create_by(name: parsed_show_name)

      next if hash_movie_function["theaters"][parse_helper].blank?

      hash_movie_function["theaters"][parse_helper].each do |functions_data|
        detected_function_types = []
        if functions_data["function_types"].present?
          functions_data["function_types"].each do |hft|
            parse_detector_types.each do |pdt|
              if !detected_function_types.include?(pdt.function_type_id) && pdt.name.downcase == hft.downcase
                detected_function_types << pdt.function_type_id
              end
            end
          end
        end
        if functions_data["functions"].present?
          functions_data["functions"].each do |hash_function|
            if hash_function["showtimes"].size >= 5
              function = functions.new
              function.show_id = parsed_show.show_id
              function.function_type_ids = detected_function_types
              function.date = current_date.advance_to_day(hash_function["dia"])
              function.parsed_show = parsed_show
              Function.create_showtimes function, hash_function["showtimes"]
              functions_to_save << function if function.showtimes.length > 0
            end
          end
        end
      end
    end if hash["movieFunctions"].present?
    override_functions(functions_to_save, current_date, parse_days_count) if functions_to_save.length > 0
  end
  
  
  def override_functions new_functions, start_date, parse_days_count

    date_range = start_date..(start_date + parse_days_count.to_i-1)
    days_with_new_functions = Hash.new
    date_range.each do |date|
      days_with_new_functions[date] = false;
    end
    new_functions.each do |func|
      break if days_with_new_functions.values.all?
      days_with_new_functions[func.date] = true if days_with_new_functions[func.date] == false
    end

    current_functions = functions.where(date: date_range).includes(:function_types, :showtimes)
    functions_to_destroy = []
    indexes_to_save = Array.new(new_functions.count, true)

    current_functions.each do |function|
      found_identical = false
      new_functions.each_with_index do |new_function, index|
        next unless indexes_to_save[index]
        if (function.total_identical?(new_function))
          found_identical = true
          indexes_to_save[index] = false
          break
        end
      end
      functions_to_destroy << function unless found_identical
    end

    functions_to_destroy.each do |f|
      f.destroy if days_with_new_functions[f.date]
    end
    indexes_to_save.each_with_index do |should_save, index|
      new_functions[index].save if should_save
    end
  end
end
