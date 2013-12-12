class Function < ActiveRecord::Base
  attr_accessible :theater_id, :show_id, :function_type_ids, :date, :showtimes_ids
  
  belongs_to :theater
  belongs_to :show
  has_and_belongs_to_many :function_types
  has_and_belongs_to_many :showtimes
  
  validates :show, presence: :true
  validates :theater, presence: :true
  validates :date, presence: :true
  
  def self.create_string_from_horarios(string)
    string.gsub(/\s{3,}|( - )|(, )|(-{4,})/, ", ")
  end
  def self.create_array_from_horarios_string(string)
    Function.create_string_from_horarios(string).split(', ')
  end
  
  # SHOWTIMES METHODS
  def self.create_showtimes(function, horarios)
    Function.create_array_from_horarios_string(horarios).each do |h|
      if h.size >= 5
        horaminuto = h.split(":")
        begin
          time = Time.new.utc.change(year:2000, month: 1, day: 1, hour: horaminuto[0], min: horaminuto[1], sec: 00)
        rescue NoMethodError
          next
        end
        function.showtimes << Showtime.find_or_create_by_time(time: time)
      end
    end
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
end
