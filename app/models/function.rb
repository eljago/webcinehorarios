class Function < ActiveRecord::Base
  attr_accessible :theater_id, :show_id, :function_type_ids, :date, :showtimes_ids
  
  belongs_to :theater
  belongs_to :show
  has_and_belongs_to_many :function_types
  has_and_belongs_to_many :showtimes
  
  # SHOWTIMES METHODS
  def self.create_showtimes(function, horarios)
    horarios.gsub(/\s{3,}|( - )|(, )/, "a").split("a").each do |h|
      if h.size >= 5
        horaminuto = h.split(":")
        function.showtimes << Showtime.find_or_create_by_time(time: Time.new.utc.change(year:2000, month: 1, day: 1, hour: horaminuto[0], min: horaminuto[1], sec: 00))
      end
    end
  end
  def self.create_extra_showtimes_from_params(function, theater)
    date = function.date
    7.times do |n|
      horarios = params["horarios_extra_#{n}"]
      date = date.next
      if horarios.size >= 5
        function = theater.functions.new
        function.date = date
        function.function_types = function.function_types
        function.show_id = function.show_id
        create_showtimes function, horarios
        function.save
      end
    end
  end
end
