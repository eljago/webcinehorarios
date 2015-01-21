# == Schema Information
#
# Table name: functions
#
#  id             :integer          not null, primary key
#  theater_id     :integer
#  show_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  date           :date
#  parsed_show_id :integer
#
# Indexes
#
#  index_functions_on_parsed_show_id  (parsed_show_id)
#  index_functions_on_show_id         (show_id)
#  index_functions_on_theater_id      (theater_id)
#

class Function < ActiveRecord::Base
  # attr_accessible :theater_id, :show_id, :function_type_ids, :date, :showtimes_ids
  
  belongs_to :theater
  belongs_to :show
  has_and_belongs_to_many :function_types
  has_many :showtimes, dependent: :destroy
  belongs_to :parsed_show
  
  validates :theater, presence: :true
  validates :date, presence: :true
  
  def self.create_string_from_horarios(string)
    string.gsub(/\s{3,}|(\s-\s)|(,\s)|(\.\s)|(-+)/, ", ")
  end
  def self.create_array_from_horarios_string(string)
    Function.create_string_from_horarios(string).split(', ')
  end
  
  # SHOWTIMES METHODS
  def self.create_showtimes(function, horarios)
    Function.create_array_from_horarios_string(horarios).each do |h|
      if h.size >= 5
        h = h.gsub(/(;)/, ":")
        horaminuto = h.split(":")
        horaminuto[0] = horaminuto[0].to_i
        horaminuto[1] = horaminuto[1].to_i
        begin
          date = horaminuto[0] < 5 ? function.date+1 : function.date
          time = DateTime.new.in_time_zone("America/Santiago").change(year: date.year, month: date.month, day: date.day, hour: horaminuto[0], min: horaminuto[1])
        rescue NoMethodError
          next
        end
        function.showtimes << Showtime.new(time: time)
      end
    end
  end
  
  def self.get_showtimes_usin_string horarios, date
    new_showtimes = []
    Function.create_array_from_horarios_string(horarios).each do |h|
      if h.size >= 5
        h = h.gsub(/(;)/, ":")
        horaminuto = h.split(":")
        horaminuto[0] = horaminuto[0].to_i
        horaminuto[1] = horaminuto[1].to_i
        begin
          new_date = horaminuto[0] < 5 ? date+1 : date
          time = DateTime.new.in_time_zone("America/Santiago").change(year: date.year, month: date.month, day: date.day, hour: horaminuto[0], min: horaminuto[1])
        rescue NoMethodError
          next
        end
        showTime = Showtime.new(time: time)
        new_showtimes << showTime
      end
    end
    new_showtimes
  end
  
  def self.create_extra_showtimes_from_params(func, theater, params)
    date = func.date
    7.times do |n|
      horarios = params["horarios_extra_#{n}"]
      date = date.next
      if horarios.size >= 5
        function = theater.functions.new
        function.date = date
        function.function_types = func.function_types
        function.show_id = func.show_id
        Function.create_showtimes function, horarios
        function.save
      end
    end
  end
  
  def total_identical? function

    return false if theater_id != function.theater_id
    return false if date != function.date
    return false if function_types.length != function.function_types.length
    return false if showtimes.length != function.showtimes.length
    
    fts = function.function_types.map(&:id).sort
    lfts = function_types.map(&:id).sort
    return false if fts != lfts
    
    sts = function.showtimes.map(&:time).sort
    lsts = showtimes.map(&:time).sort
    return false if sts != lsts
    
    return false if !(show_id == function.show_id || parsed_show_id == function.parsed_show_id)
    
    return true
  end
  
end
