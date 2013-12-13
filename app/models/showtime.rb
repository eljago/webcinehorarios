class Showtime < ActiveRecord::Base
  
  attr_accessible :time
  
  validates :time, presence: true, uniqueness: true
  
  belongs_to :function
end
