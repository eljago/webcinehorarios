class Function < ApplicationRecord
  
  belongs_to :theater
  belongs_to :show
  has_and_belongs_to_many :function_types
  belongs_to :parsed_show
  
  validates :theater, existence: true
  validates :date, presence: :true
  
  validates :showtimes, presence: :true
  validates :showtimes, format: {
      with: /\A(([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9], )*([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]\z/,
      message: "%{value} no es un formato válido"
    }, allow_blank: true

  def total_identical? function

    return false if theater_id != function.theater_id
    return false if date != function.date
    return false if function_types.size != function.function_types.size
    return false if showtimes != function.showtimes
    
    fts = function.function_types.map(&:id).sort
    lfts = function_types.map(&:id).sort
    return false if fts != lfts
    
    return false if (show_id != function.show_id || parsed_show_id != function.parsed_show_id)
    
    return true
  end
  
end
