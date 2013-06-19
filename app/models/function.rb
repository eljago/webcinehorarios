class Function < ActiveRecord::Base
  attr_accessible :theater_id, :show_id, :function_type_ids, :date, :showtimes_ids
  
  belongs_to :theater
  belongs_to :show
  has_and_belongs_to_many :function_types
  has_and_belongs_to_many :showtimes
end
