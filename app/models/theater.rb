class Theater < ApplicationRecord
  include Graphqlable
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :city
  belongs_to :cinema
  has_many :functions, :dependent => :destroy

  validates :name, :presence => :true

  accepts_nested_attributes_for :functions, allow_destroy: true

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
    Cinema.select(:id).each do |cinema|
      Rails.cache.delete([self.class.name, "api_theaters", cinema.id])
    end
  end

  def task_parsed_hash hash
    function_types = cinema.function_types.order(:name)
    parse_detector_types = cinema.parse_detector_types.order('LENGTH(name) DESC')
    current_date = Date.current
    parse_days_count = 7
    date_range = current_date..(current_date+parse_days_count-1)

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
              f_date = current_date.advance_to_day(hash_function["dia"])
              next if !date_range.include?(f_date)
              function = functions.new
              function.show_id = parsed_show.show_id
              function.function_type_ids = detected_function_types
              function.date = f_date
              function.parsed_show = parsed_show
              function.showtimes = hash_function["showtimes"]
              functions_to_save << function if function.showtimes.size > 0
            end
          end
        end
      end
    end if hash["movieFunctions"].present?
    override_functions(functions_to_save, current_date, parse_days_count) if functions_to_save.length > 0
  end
  
  
  def override_functions new_functions, start_date, parse_days_count

    current_functions = functions.includes(:function_types)

    new_functions_hash = {}
    new_functions.each do |f|
      new_functions_hash[f.date] = [] if new_functions_hash[f.date].blank?
      new_functions_hash[f.date] << f
    end

    current_functions_hash = {}
    current_functions.each do |f|
      current_functions_hash[f.date] = [] if current_functions_hash[f.date].blank?
      current_functions_hash[f.date] << f
    end

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

    functions_to_destroy_hash = {} # functions_to_destroy grouped by date
    functions_to_destroy.each do |f|
      functions_to_destroy_hash[f.date] = [] if functions_to_destroy_hash[f.date].blank?
      functions_to_destroy_hash[f.date] << f
    end

    functions_to_destroy.each do |f|
      # don't destroy if there are no new functions for that day, so it doesn't end up empty (cinemark)
      if new_functions_hash[f.date].present? && new_functions_hash[f.date].length != 0
        f.destroy
      end
    end

    indexes_to_save.each_with_index do |should_save, index|
      new_functions[index].save if should_save
    end
  end
end
